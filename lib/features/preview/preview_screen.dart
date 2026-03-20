import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_manager/common/layout/invoice_layout_breakpoints.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../common/services/invoice_pdf_generator/invoice_pdf_generator.dart';
import '../../routing/app_router.dart';
import 'services/export_pdf_service.dart';

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
          onPressed: () => _backFromPreview(context),
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
            onPressed: () => exportPdf(context, ref, invoiceId),
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
                onPressed: () => _backFromPreview(context),
                child: const Text('Zurück'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _backFromPreview(BuildContext context) {
    if (isWideInvoiceLayout(context)) {
      context.go(pathEdit(invoiceId));
    } else {
      context.pop();
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
