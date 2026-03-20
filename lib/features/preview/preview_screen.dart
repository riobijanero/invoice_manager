import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart' as fs;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../common/services/invoice_pdf_generator/invoice_pdf_generator.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncInvoice = ref.watch(invoiceDetailProvider(invoiceId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF-Vorschau'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Zurück',
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _print(context, ref),
            icon: const Icon(Icons.print),
            label: const Text('Drucken'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => _exportPdf(context, ref),
            icon: const Icon(Icons.save_alt),
            label: const Text('PDF exportieren…'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: asyncInvoice.when(
        data: (invoice) {
          if (invoice == null) {
            return const Center(
              child: Text('Rechnung nicht gefunden.'),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              // A4 aspect ratio (height/width). We use it to scale down the page
              // so the entire sheet is visible even when the window is short.
              const double a4Aspect = 297.0 / 210.0;
              final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : 800;
              final maxHeight = constraints.maxHeight.isFinite ? constraints.maxHeight : 1000;
              final scaledMaxPageWidth = math.min(maxWidth, maxHeight / a4Aspect).toDouble();

              return PdfPreview(
                build: (PdfPageFormat format) => generateInvoicePdf(invoice),
                allowPrinting: false,
                allowSharing: false,
                // Keep zoom/page controls available, but let the viewport scaling
                // ensure the full page stays visible on small windows.
                useActions: true,
                canChangeOrientation: false,
                canChangePageFormat: false,
                pdfFileName: 'Rechnung-${invoice.invoiceNumber}.pdf',
                maxPageWidth: scaledMaxPageWidth,
                previewPageMargin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Fehler: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Zurück'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final invoice = await ref.read(invoiceDetailProvider(invoiceId).future);
      if (invoice == null || !context.mounted) return;

      final bytes = await generateInvoicePdf(invoice);

      final safeInvoiceNumber = invoice.invoiceNumber.trim().replaceAll(
            RegExp(r'[^a-zA-Z0-9._-]'),
            '_',
          );
      final safeFileName = 'Rechnung-${safeInvoiceNumber.isEmpty ? 'unnamed' : safeInvoiceNumber}.pdf';

      final tempDir = await Directory.systemTemp.createTemp('invoice_manager_pdf_');
      final tempFile = File(path.join(tempDir.path, safeFileName));
      await tempFile.writeAsBytes(bytes, flush: true);

      // 1) First attempt: macOS-friendly save dialog via file_picker.
      String? pickedPath;
      try {
        debugPrint('PDF export: opening file_picker save dialog...');
        pickedPath = await FilePicker.platform.saveFile(
          fileName: safeFileName,
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        debugPrint('PDF export: file_picker returned pickedPath=$pickedPath');
      } on PlatformException catch (e) {
        debugPrint('PDF export: file_picker PlatformException: ${e.message ?? e.code}');
      } catch (e) {
        debugPrint('PDF export: file_picker unexpected error: $e');
      }

      if (pickedPath != null) {
        // On macOS, `file_picker.saveFile` doesn't reliably support passing raw bytes.
        // So we only use it to get the destination path and then write the bytes ourselves.
        await File(pickedPath).writeAsBytes(bytes, flush: true);
        if (context.mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text('PDF wurde gespeichert')),
          );
        }
        return;
      }

      // 2) Fallback: file_selector (may fail on some macOS setups).
      try {
        final saveLocation = await fs.getSaveLocation(suggestedName: safeFileName);
        debugPrint('PDF export: file_selector returned saveLocation=${saveLocation?.path}');

        if (saveLocation != null) {
          await File(saveLocation.path).writeAsBytes(bytes, flush: true);
          if (context.mounted) {
            messenger.showSnackBar(
              const SnackBar(content: Text('PDF wurde gespeichert')),
            );
          }
          return;
        }
      } on PlatformException catch (e) {
        debugPrint('PDF export: file_selector PlatformException: ${e.message ?? e.code}');
      } catch (e) {
        debugPrint('PDF export: file_selector unexpected error: $e');
      }

      // 3) Last resort: auto-save so export never "does nothing".
      final baseDir = await getApplicationDocumentsDirectory();
      final exportDir =
          Directory(path.join(baseDir.path, 'invoice_manager', 'exports'));
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }
      final outPath = path.join(exportDir.path, safeFileName);
      debugPrint('PDF export: falling back to auto-save: $outPath');
      await File(outPath).writeAsBytes(bytes, flush: true);
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('PDF wurde gespeichert (ohne Dialog): $outPath')),
        );
      }
    } on PlatformException catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'PDF Export fehlgeschlagen (file_selector): ${e.message ?? e.code}',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('PDF Export fehlgeschlagen: $e')),
      );
    }
  }

  Future<void> _print(BuildContext context, WidgetRef ref) async {
    final invoice = await ref.read(invoiceDetailProvider(invoiceId).future);
    if (invoice == null || !context.mounted) return;
    final bytes = await generateInvoicePdf(invoice);
    await Printing.layoutPdf(
      onLayout: (_) => Future.value(bytes),
      name: 'Rechnung-${invoice.invoiceNumber}.pdf',
    );
  }
}
