import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/config.dart';
import 'package:invoice_manager/common/services/utils.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const double _kEinheitW = 42;
const double _kMengeW = 38;
const double _kPreisW = 48;
const double _kGesamtW = 65;

/// Width of Einheit + Menge + Preis (merged for fixed-price rows).
const double _kMergedEinheitMengePreisW = _kEinheitW + _kMengeW + _kPreisW;

const pw.BorderSide _tableBorderSide = pw.BorderSide(width: 0.5, color: PdfColors.grey800);

/// Outer + internal borders for 5-column hourly rows (same as [pw.TableBorder.all]).
pw.TableBorder _hourlyRowTableBorder({required bool top}) {
  return pw.TableBorder(
    left: _tableBorderSide,
    right: _tableBorderSide,
    bottom: _tableBorderSide,
    top: top ? _tableBorderSide : pw.BorderSide.none,
    verticalInside: _tableBorderSide,
    horizontalInside: _tableBorderSide,
  );
}

/// Fixed-price row: no vertical lines between Beschreibung and Gesamt except before Gesamt (drawn on Gesamt cell).
pw.TableBorder _fixedPriceRowTableBorder({required bool top}) {
  return pw.TableBorder(
    left: _tableBorderSide,
    right: _tableBorderSide,
    bottom: _tableBorderSide,
    top: top ? _tableBorderSide : pw.BorderSide.none,
    verticalInside: pw.BorderSide.none,
    horizontalInside: pw.BorderSide.none,
  );
}

const Map<int, pw.TableColumnWidth> _fiveColumnWidths = {
  0: pw.FlexColumnWidth(1), // Beschreibung
  1: pw.FixedColumnWidth(_kEinheitW), // Einheit
  2: pw.FixedColumnWidth(_kMengeW), // Menge
  3: pw.FixedColumnWidth(_kPreisW), // Preis
  4: pw.FixedColumnWidth(_kGesamtW), // Gesamt
};

const Map<int, pw.TableColumnWidth> _fixedPriceThreeColumnWidths = {
  0: pw.FlexColumnWidth(1), // Beschreibung
  1: pw.FixedColumnWidth(_kMergedEinheitMengePreisW), // merged empty
  2: pw.FixedColumnWidth(_kGesamtW), // Gesamt
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

  return [
    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // Header (5 columns)
        pw.Table(
          border: _hourlyRowTableBorder(top: true),
          columnWidths: _fiveColumnWidths,
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                cell('Beschreibung', bold: true),
                cell('Einheit', bold: true),
                cell('Menge', bold: true),
                cell('Preis', bold: true),
                cell('Gesamt', bold: true, alignRight: true),
              ],
            ),
          ],
        ),
        if (items.isEmpty)
          pw.Table(
            border: _hourlyRowTableBorder(top: false),
            columnWidths: _fiveColumnWidths,
            children: [
              pw.TableRow(
                children: [
                  cell(''),
                  cell('Std.'),
                  cell('0'),
                  cell(formatCurrency(0)),
                  cell(formatCurrency(0), alignRight: true),
                ],
              ),
            ],
          )
        else
          for (int i = 0; i < items.length; i++)
            items[i].type == InvoiceItemType.fixedPriceService
                ? pw.Table(
                    border: _fixedPriceRowTableBorder(top: false),
                    columnWidths: _fixedPriceThreeColumnWidths,
                    children: [
                      pw.TableRow(
                        children: [
                          cell(
                            serviceDescriptions.length > i ? serviceDescriptions[i] : '',
                          ),
                          cell(''),
                          pw.Container(
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(left: _tableBorderSide),
                            ),
                            child: cell(
                              formatCurrency(items[i].itemTotal),
                              alignRight: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : pw.Table(
                    border: _hourlyRowTableBorder(top: false),
                    columnWidths: _fiveColumnWidths,
                    children: [
                      pw.TableRow(
                        children: [
                          cell(
                            serviceDescriptions.length > i ? serviceDescriptions[i] : '',
                          ),
                          cell(items[i].unitLabel),
                          cell(items[i].quantity.toStringAsFixed(0)),
                          cell(formatCurrency(items[i].unitPrice)),
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
    // Totals table directly under the main table, same width and visually connected.
    pw.Table(
      border: const pw.TableBorder(
        top: pw.BorderSide.none,
        left: pw.BorderSide(width: 0.5, color: PdfColors.grey800),
        right: pw.BorderSide(width: 0.5, color: PdfColors.grey800),
        bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey800),
        verticalInside: pw.BorderSide.none,
        horizontalInside: pw.BorderSide(width: 0.5, color: PdfColors.grey800),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FixedColumnWidth(_kGesamtW),
      },
      children: [
        if (showDiscountBreakdown) ...[
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: pw.Text(
                  'Zwischensumme (netto)',
                  style: const pw.TextStyle(fontSize: fontSizeMain),
                ),
              ),
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(left: _tableBorderSide),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      formatCurrency(totals.subtotal),
                      style: const pw.TextStyle(fontSize: fontSizeMain),
                    ),
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
                  discountLabel(),
                  style: const pw.TextStyle(fontSize: fontSizeMain),
                ),
              ),
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(left: _tableBorderSide),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      formatCurrency(-totals.discountAmount),
                      style: const pw.TextStyle(fontSize: fontSizeMain),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: pw.Text(
                'Gesamtbetrag (netto)',
                style: const pw.TextStyle(fontSize: fontSizeMain),
              ),
            ),
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(left: _tableBorderSide),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    formatCurrency(totals.net),
                    style: const pw.TextStyle(fontSize: fontSizeMain),
                  ),
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
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(left: _tableBorderSide),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    formatCurrency(totals.vat),
                    style: const pw.TextStyle(fontSize: fontSizeMain),
                  ),
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
                'Gesamtbetrag (brutto)',
                style: pw.TextStyle(
                  fontSize: fontSizeMain,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(left: _tableBorderSide),
              ),
              child: pw.Padding(
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
            ),
          ],
        ),
      ],
    ),
  ];
}
