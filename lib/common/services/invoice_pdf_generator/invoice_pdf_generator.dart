import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:invoice_manager/common/services/invoice_pdf_generator/invoice_header.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/title_block.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/invoice_table_block.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/bank_details.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/config.dart';
import 'package:invoice_manager/features/QR_code_generation/services/qr_generation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import '../../utils/date_utils.dart';
import '../../utils/invoice_calculations.dart';

/// Generates PDF bytes for an invoice matching the German template layout.
/// Uses embedded **Open Sans** (OFL) from `assets/fonts/` so € and Unicode work
/// without network. TTFs must be real font files (not HTML placeholders).
Future<Uint8List> generateInvoicePdf(Invoice invoice) async {
  final baseFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'),
  );
  final boldFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'),
  );
  final dueDate = computeDueDate(invoice);
  final itemList = invoice.invoiceItemList;
  final itemsWithPeriod = itemList.where((InvoiceItem i) => i.hasServicePeriod).toList();

  // Title: show Leistungszeitraum line only when at least one position has month+year.
  final String? periodText;
  if (itemsWithPeriod.isEmpty) {
    periodText = null;
  } else {
    final firstItem = itemsWithPeriod.first;
    final lastItem = itemsWithPeriod.last;
    final periodStartDate = periodStart(firstItem.serviceMonth!, firstItem.serviceYear!);
    final periodEndDate = periodEnd(lastItem.serviceMonth!, lastItem.serviceYear!);
    periodText = '${formatDate(periodStartDate)} - ${formatDate(periodEndDate)}';
  }

  // One row per invoice item; {PERIOD} replaced only when that line has a Zeitraum.
  final serviceDescriptionsForPdf = itemList.map((InvoiceItem item) {
    final desc = item.serviceDescription;
    if (!item.hasServicePeriod) {
      return desc.replaceAll('{PERIOD}', '').trim();
    }
    final start = periodStart(item.serviceMonth!, item.serviceYear!);
    final end = periodEnd(item.serviceMonth!, item.serviceYear!);
    final itemPeriodText = '${formatDate(start)} - ${formatDate(end)}';
    return desc.replaceAll('{PERIOD}', itemPeriodText).trim();
  }).toList();

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: baseFont, bold: boldFont),
      margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      footer: (pw.Context context) {
        return pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Seite ${context.pageNumber} von ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: fontSizeXSmall),
          ),
        );
      },
      build: (pw.Context context) {
        return [
          ...invoiceHeader(invoice),
          pw.SizedBox(height: 80),

          ...titleBlock(
            invoice: invoice,
            periodText: periodText,
          ),
          pw.SizedBox(height: 50),
          // Intro text comes from the invoice data model
          pw.Text(
            invoice.introductoryText,
            style: const pw.TextStyle(fontSize: fontSizeMain),
          ),
          pw.SizedBox(height: 16),
          ...invoiceTableBlock(
            invoice: invoice,
            serviceDescriptions: serviceDescriptionsForPdf,
          ),
          pw.SizedBox(height: 24),
          if (invoice.vat == 0) ...[
            pw.Text(
              'Gemäß §19 Abs. 1 UStG wird keine Umsatzsteuer erhoben.',
              style: const pw.TextStyle(fontSize: fontSizeMain),
            ),
            pw.SizedBox(height: 0),
          ],
          // Payment sentence
          pw.Text(
            'Bitte überweisen Sie den Betrag unter Angabe der Rechnungsnr bis zum ${formatDate(dueDate)} auf das folgende Konto:',
            style: const pw.TextStyle(fontSize: fontSizeMain),
          ),
          pw.SizedBox(height: 10),
          ...bankDetailsBlock(invoice.bankDetails),
          if (invoice.hasQrCode) ...[
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.BarcodeWidget(
                data: QrGenerationService().generateGiroCodeString(invoice),
                barcode: pw.Barcode.qrCode(),
                drawText: false,
                width: 100,
                height: 100,
              ),
            ),
          ],
          pw.SizedBox(height: 40),
          pw.Text(
            'Mit freundlichen Grüßen',
            style: const pw.TextStyle(fontSize: fontSizeMain),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            invoice.bankDetails.accountHolder,
            style: const pw.TextStyle(fontSize: fontSizeMain),
          ),
        ];
      },
    ),
  );

  return doc.save();
}
