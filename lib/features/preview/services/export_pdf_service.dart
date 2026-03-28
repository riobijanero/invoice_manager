import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart' as fs;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../common/services/invoice_pdf_generator/invoice_pdf_generator.dart';

/// Speichert die Rechnung als PDF: zuerst [FilePicker], bei Fehler [getSaveLocation],
/// zuletzt automatisch unter `Documents/invoice_manager/exports` (nur wenn die Dialoge
/// mit einer Exception scheitern — **nicht** nach Abbruch durch den Nutzer).
Future<void> exportPdf(
  BuildContext context,
  WidgetRef ref,
  String invoiceId,
) async {
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

    // 1) First attempt: macOS-friendly save dialog via file_picker.
    // `saveFile` returns null when the user cancels — do not fall through to another
    // dialog or auto-save (that felt like a bug: second dialog + unwanted download).
    String? pickedPath;
    var filePickerThrew = false;
    try {
      debugPrint('PDF export: opening file_picker save dialog...');
      pickedPath = await FilePicker.platform.saveFile(
        fileName: safeFileName,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      debugPrint('PDF export: file_picker returned pickedPath=$pickedPath');
    } on PlatformException catch (e) {
      filePickerThrew = true;
      debugPrint('PDF export: file_picker PlatformException: ${e.message ?? e.code}');
    } catch (e) {
      filePickerThrew = true;
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

    if (!filePickerThrew) {
      // null without exception: user dismissed the dialog (or equivalent).
      return;
    }

    // 2) Fallback: file_selector when file_picker failed with an exception.
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
      // null: user cancelled — do not auto-save.
      return;
    } on PlatformException catch (e) {
      debugPrint('PDF export: file_selector PlatformException: ${e.message ?? e.code}');
    } catch (e) {
      debugPrint('PDF export: file_selector unexpected error: $e');
    }

    // 3) Last resort: auto-save only when file_selector threw (file_picker already failed).
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
