import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

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
          return PdfPreview(
            build: (PdfPageFormat format) => generateInvoicePdf(invoice),
            allowPrinting: true,
            allowSharing: false,
            useActions: false,
            pdfFileName: 'Rechnung-${invoice.invoiceNumber}.pdf',
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
    final invoice = await ref.read(invoiceDetailProvider(invoiceId).future);
    if (invoice == null || !context.mounted) return;
    final bytes = await generateInvoicePdf(invoice);
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'PDF speichern',
      fileName: 'Rechnung-${invoice.invoiceNumber}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (path == null || !context.mounted) return;
    await File(path).writeAsBytes(bytes);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF wurde gespeichert')),
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
