import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:invoice_manager/services/invoice_pdf_generator/invoice_header.dart';
import 'package:invoice_manager/services/invoice_pdf_generator/title_block.dart';
import 'package:invoice_manager/services/invoice_pdf_generator/invoice_table_block.dart';
import 'package:invoice_manager/services/invoice_pdf_generator/bank_details.dart';
import 'package:invoice_manager/services/invoice_pdf_generator/config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:invoice_manager/common/models/invoice.dart';
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
  final periodStartDate = periodStart(invoice.serviceMonth, invoice.serviceYear);
  final periodEndDate = periodEnd(invoice.serviceMonth, invoice.serviceYear);
  final periodText = '${formatDate(periodStartDate)} - ${formatDate(periodEndDate)}';
  // Ensure service description in PDF always shows current invoice period (replace placeholder)
  final serviceDescriptionForPdf = invoice.serviceDescription.replaceAll('{PERIOD}', periodText).trim();

  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: baseFont, bold: boldFont),
      margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            ...invoiceHeader(invoice),
            pw.SizedBox(height: 60),

            ...titleBlock(
              invoice: invoice,
              periodText: periodText,
            ),
            pw.SizedBox(height: 48),
            // Greeting
            pw.Text(
              'Sehr geehrte Damen und Herren,',
              style: const pw.TextStyle(fontSize: fontSizeMain),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              'für das Erbringen meiner Dienstleistungen berechne ich Ihnen:',
              style: const pw.TextStyle(fontSize: fontSizeMain),
            ),
            pw.SizedBox(height: 16),
            ...invoiceTableBlock(
              invoice: invoice,
              serviceDescription: serviceDescriptionForPdf,
            ),
            pw.SizedBox(height: 24),
            // Payment sentence
            pw.Text(
              'Bitte überweisen Sie den Betrag unter Angabe der Rechnungsnummer bis zum ${formatDate(dueDate)} auf das folgende Konto:',
              style: const pw.TextStyle(fontSize: fontSizeMain),
            ),
            pw.SizedBox(height: 10),
            ...bankDetailsBlock(invoice.bankDetails),
            pw.SizedBox(height: 20),
            pw.Text(
              'Mit freundlichen Grüßen',
              style: const pw.TextStyle(fontSize: fontSizeMain),
            ),
            pw.SizedBox(height: 24),
            pw.Text(
              '____________________',
              style: const pw.TextStyle(fontSize: fontSizeMain),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              invoice.bankDetails.accountHolder,
              style: const pw.TextStyle(fontSize: fontSizeMain),
            ),
          ],
        );
      },
    ),
  );

  return doc.save();
}
