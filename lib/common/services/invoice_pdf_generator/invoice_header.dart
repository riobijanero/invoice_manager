import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/client_block.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/sender_block.dart';
import 'package:pdf/widgets.dart' as pw;

/// Header row: client block on the left, sender block on the right.
List<pw.Widget> invoiceHeader(Invoice invoice) {
  return [
    pw.SizedBox(height: 16),
    pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Align(
            alignment: pw.Alignment.bottomLeft,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: clientBlock(invoice.client, invoice.sender),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: senderBlock(invoice.sender),
          ),
        ),
      ],
    ),
  ];
}
