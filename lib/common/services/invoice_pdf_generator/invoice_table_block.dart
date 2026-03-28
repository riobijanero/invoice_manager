import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/config.dart';
import 'package:invoice_manager/common/services/utils.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
import 'package:invoice_manager/common/utils/quantity_format.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const double _kPosWidth = 30;
const double _kEinheitWidth = 48;
const double _kAnzahlWidth = 48;
const double _kEinzelpreisWidth = 58;
const double _kGesamtWidth = 62;

const pw.BorderSide _tableBorderSide = pw.BorderSide(width: 0.5, color: PdfColors.grey800);

/// No table strokes (header, empty row, totals).
const pw.TableBorder _kBorderNone = pw.TableBorder(
  top: pw.BorderSide.none,
  left: pw.BorderSide.none,
  right: pw.BorderSide.none,
  bottom: pw.BorderSide.none,
  verticalInside: pw.BorderSide.none,
  horizontalInside: pw.BorderSide.none,
);

/// Bottom edge only under each [InvoiceItem] row (not header / not totals).
const pw.TableBorder _kInvoiceItemRowBorder = pw.TableBorder(
  left: pw.BorderSide.none,
  right: pw.BorderSide.none,
  top: pw.BorderSide.none,
  bottom: _tableBorderSide,
  verticalInside: pw.BorderSide.none,
  horizontalInside: pw.BorderSide.none,
);

/// Pos. | Beschreibung | Einheit | Anzahl | Einzelpreis | Gesamt
const Map<int, pw.TableColumnWidth> _sixColumnWidths = {
  0: pw.FixedColumnWidth(_kPosWidth), // Pos.
  1: pw.FlexColumnWidth(1), // Beschreibung
  2: pw.FixedColumnWidth(_kEinheitWidth),
  3: pw.FixedColumnWidth(_kAnzahlWidth),
  4: pw.FixedColumnWidth(_kEinzelpreisWidth),
  5: pw.FixedColumnWidth(_kGesamtWidth),
};

/// Main invoice table (line item + totals) used in the PDF body.
List<pw.Widget> invoiceTableBlock({
  required Invoice invoice,
  required List<String> serviceDescriptions,
}) {
  final totals = computeTotals(invoice);
  final items = invoice.invoiceItemList;
  final showDiscountBreakdown = totals.discountAmount > 0.0001;

  String discountLabel() {
    if (invoice.discountType == DiscountType.percent) {
      final v = invoice.discountValue;
      final pct = v == v.truncateToDouble() ? v.toInt().toString() : v.toString();
      return 'Rabatt ($pct %)';
    }
    return 'Rabatt (Betrag)';
  }

  String vatLabel() {
    final pctValue = invoice.vat * 100;
    final pct = pctValue == pctValue.truncateToDouble() ? pctValue.toInt().toString() : pctValue.toStringAsFixed(2);
    return 'Umsatzsteuer $pct %';
  }

  return [
    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // Header
        pw.Table(
          border: _kBorderNone,
          columnWidths: _sixColumnWidths,
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                cell('Pos.', bold: true),
                cell('Beschreibung', bold: true),
                cell('Einheit', bold: true, alignRight: true),
                cell('Anzahl', bold: true, alignRight: true),
                cell('Einzelpreis', bold: true, alignRight: true),
                cell('Gesamt', bold: true, alignRight: true),
              ],
            ),
          ],
        ),
        if (items.isEmpty)
          pw.Table(
            border: _kBorderNone,
            columnWidths: _sixColumnWidths,
            children: [
              pw.TableRow(
                children: [
                  cell('1'),
                  cell(''),
                  cell('Std.', alignRight: true),
                  cell('0', alignRight: true),
                  cell(formatCurrency(0), alignRight: true),
                  cell(formatCurrency(0), alignRight: true),
                ],
              ),
            ],
          )
        else
          for (int i = 0; i < items.length; i++)
            pw.Table(
              border: _kInvoiceItemRowBorder,
              columnWidths: _sixColumnWidths,
              children: [
                pw.TableRow(
                  children: [
                    cell('${items[i].position}'),
                    cell(
                      serviceDescriptions.length > i ? serviceDescriptions[i] : '',
                    ),
                    cell(items[i].unitLabel, alignRight: true),
                    cell(formatQuantityForDisplay(items[i].quantity), alignRight: true),
                    cell(formatCurrency(items[i].unitPrice), alignRight: true),
                    cell(
                      formatCurrency(items[i].itemTotal),
                      alignRight: true,
                    ),
                  ],
                ),
              ],
            ),
      ],
    ),
    // Totals: empty column matches Pos.; flex label aligns with Beschreibung…Einzelpreis; amount with Gesamt.
    pw.Table(
      border: _kBorderNone,
      columnWidths: const {
        0: pw.FixedColumnWidth(_kPosWidth),
        1: pw.FlexColumnWidth(1),
        2: pw.FixedColumnWidth(_kGesamtWidth),
      },
      children: [
        if (showDiscountBreakdown) ...[
          pw.TableRow(
            children: [
              pw.SizedBox(),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: pw.Text(
                  'Zwischensumme (netto)',
                  style: const pw.TextStyle(fontSize: fontSizeMain),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    formatCurrency(totals.subtotal),
                    style: const pw.TextStyle(fontSize: fontSizeMain),
                  ),
                ),
              ),
            ],
          ),
          pw.TableRow(
            children: [
              pw.SizedBox(),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: pw.Text(
                  discountLabel(),
                  style: const pw.TextStyle(fontSize: fontSizeMain),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    formatCurrency(-totals.discountAmount),
                    style: const pw.TextStyle(fontSize: fontSizeMain),
                  ),
                ),
              ),
            ],
          ),
        ],
        pw.TableRow(
          children: [
            pw.SizedBox(),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Text(
                'Gesamtbetrag (netto)',
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
            pw.SizedBox(),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Text(
                vatLabel(),
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
            pw.SizedBox(),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Text(
                'Gesamtbetrag (brutto)',
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
