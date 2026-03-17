import 'package:invoice_manager/models/invoice.dart';
import 'package:invoice_manager/services/invoice_pdf_generator/config.dart';
import 'package:invoice_manager/services/utils.dart';
import 'package:invoice_manager/utils/date_utils.dart';
import 'package:pdf/widgets.dart' as pw;

/// Title row: invoice title + contract + period on the left, meta table (date, number, USt-ID, contract) on the right.
List<pw.Widget> titleBlock({
  required Invoice invoice,
  required String periodText,
}) {
  return [
    pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Rechnung | Nr. ${invoice.invoiceNumber}',
                style: pw.TextStyle(
                  fontSize: fontSizeLarge,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Leistungszeitraum: $periodText',
                style: const pw.TextStyle(fontSize: fontSizeMain),
              ),
            ],
          ),
        ),
        pw.SizedBox(
          width: rightColumnsWidth,
          child: pw.Table(
            children: [
              tableRow('Datum:', formatDate(invoice.invoiceDate)),
              tableRow('Rechnungsnr.:', invoice.invoiceNumber),
              if (invoice.contractNumber.isNotEmpty) tableRow('Kontraktnr.:', invoice.contractNumber),
            ],
          ),
        ),
      ],
    ),
  ];
}
