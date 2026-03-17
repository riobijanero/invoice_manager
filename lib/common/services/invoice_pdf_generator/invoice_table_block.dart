import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/config.dart';
import 'package:invoice_manager/common/services/utils.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Main invoice table (line item + totals) used in the PDF body.
List<pw.Widget> invoiceTableBlock({
  required Invoice invoice,
  required String serviceDescription,
}) {
  final totals = computeTotals(invoice);
  final lineTotal = invoice.hours * invoice.hourlyRate;

  return [
    // Line-item table
    pw.Table(
      border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey800),
      columnWidths: {
        0: const pw.FixedColumnWidth(28),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FixedColumnWidth(42),
        3: const pw.FixedColumnWidth(38),
        4: const pw.FixedColumnWidth(44),
        5: const pw.FixedColumnWidth(52),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            cell('Pos.', bold: true),
            cell('Bezeichnung', bold: true),
            cell('Einheit', bold: true),
            cell('Menge', bold: true),
            cell('Preis', bold: true),
            cell('Gesamt', bold: true),
          ],
        ),
        pw.TableRow(
          children: [
            cell('1'),
            cell(serviceDescription),
            cell('Std.'),
            cell(invoice.hours.toStringAsFixed(0)),
            cell(formatCurrency(invoice.hourlyRate)),
            cell(formatCurrency(lineTotal)),
          ],
        ),
      ],
    ),
    // Totals table directly under the main table, same width and visually connected.
    pw.Table(
      border: pw.TableBorder(
        top: pw.BorderSide.none,
        left: const pw.BorderSide(width: 0.5, color: PdfColors.grey800),
        right: const pw.BorderSide(width: 0.5, color: PdfColors.grey800),
        bottom: const pw.BorderSide(width: 0.5, color: PdfColors.grey800),
        horizontalInside: const pw.BorderSide(width: 0.5, color: PdfColors.grey800),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Text(
                'Gesamt (netto)',
                style: const pw.TextStyle(fontSize: fontSizeMain),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  formatCurrency(totals.net),
                  style: const pw.TextStyle(fontSize: fontSizeMain),
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Text(
                'Umsatzsteuer 19 %',
                style: const pw.TextStyle(fontSize: fontSizeMain),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  formatCurrency(totals.vat),
                  style: const pw.TextStyle(fontSize: fontSizeMain),
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Text(
                'Gesamt (brutto)',
                style: pw.TextStyle(
                  fontSize: fontSizeMain,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  formatCurrency(totals.gross),
                  style: pw.TextStyle(
                    fontSize: fontSizeMain,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ];
}
