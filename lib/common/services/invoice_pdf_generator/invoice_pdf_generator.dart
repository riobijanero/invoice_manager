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

/// Kalendertag (ohne Uhrzeit) für Vergleiche und PDF-Zeilen.
DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Start/Ende des Leistungszeitraums pro Position (Monat+Jahr **oder** einzelnes Datum).
(DateTime start, DateTime end) _itemPeriodBounds(InvoiceItem item) {
  if (item.serviceDate != null) {
    final d = _dateOnly(item.serviceDate!);
    return (d, d);
  }
  final m = item.serviceMonth!;
  final y = item.serviceYear!;
  return (periodStart(m, y), periodEnd(m, y));
}

String _formatPeriodRange(DateTime start, DateTime end) {
  if (start.year == end.year && start.month == end.month && start.day == end.day) {
    return formatDate(start);
  }
  return '${formatDate(start)} - ${formatDate(end)}';
}

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

  // Title: Leistungszeitraum über alle Positionen mit Zeitraum (Monat/Jahr oder Datum).
  final String? periodText;
  if (itemsWithPeriod.isEmpty) {
    periodText = null;
  } else {
    final firstBounds = _itemPeriodBounds(itemsWithPeriod.first);
    var rangeStart = firstBounds.$1;
    var rangeEnd = firstBounds.$2;
    for (final item in itemsWithPeriod.skip(1)) {
      final (s, e) = _itemPeriodBounds(item);
      if (s.isBefore(rangeStart)) rangeStart = s;
      if (e.isAfter(rangeEnd)) rangeEnd = e;
    }
    periodText = _formatPeriodRange(rangeStart, rangeEnd);
  }

  // One row per invoice item; {PERIOD} replaced only when that line has a Zeitraum.
  final serviceDescriptionsForPdf = itemList.map((InvoiceItem item) {
    final desc = item.serviceDescription;
    if (!item.hasServicePeriod) {
      return desc.replaceAll('{PERIOD}', '').trim();
    }
    final (start, end) = _itemPeriodBounds(item);
    final itemPeriodText = _formatPeriodRange(start, end);
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
          if (invoice.hasQrCode)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: bankDetailsBlock(invoice.bankDetails),
                  ),
                ),
                pw.SizedBox(width: 4),
                pw.Container(
                  width: 60,
                  height: 60,
                  alignment: pw.Alignment.topRight,
                  child: pw.BarcodeWidget(
                    data: QrGenerationService().generateGiroCodeString(invoice),
                    barcode: pw.Barcode.qrCode(),
                    drawText: false,
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            )
          else
            ...bankDetailsBlock(invoice.bankDetails),
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
