import 'package:invoice_manager/common/models/sender.dart';
import 'package:invoice_manager/services/invoice_pdf_generator/config.dart';
import 'package:invoice_manager/services/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const rowAlignment = pw.MainAxisAlignment.start;
const textAlignment = pw.TextAlign.left;
const columnAlignment = pw.CrossAxisAlignment.start;
const contentAlignment = pw.Alignment.centerLeft;
const contentWidth = rightColumnsWidth;

const pw.TextStyle _senderTextStyle = pw.TextStyle(fontSize: fontSizeMain);

pw.Widget _senderLine(String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 1),
      child: pw.Text(
        text,
        style: _senderTextStyle,
        textAlign: textAlignment,
      ),
    );

pw.Widget _senderFieldRow(pw.Widget content) => pw.Row(
      mainAxisAlignment: rowAlignment,
      children: [
        pw.Expanded(child: pw.SizedBox.shrink()),
        pw.SizedBox(
          width: contentWidth,
          child: pw.Align(
            alignment: contentAlignment,
            child: content,
          ),
        ),
      ],
    );

List<pw.Widget> senderBlock(Sender sender) {
  final addressLines =
      sender.address.split(RegExp(r'[\r\n]+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  // One widget per sender field – reorder this list to change layout.
  final nameField = _senderFieldRow(
    pw.Text(
      sender.name,
      style: _senderTextStyle.copyWith(color: PdfColor.fromHex('#003366')),
      textAlign: textAlignment,
    ),
  );
  final jobDescriptionField = sender.jobDescription.trim().isNotEmpty
      ? _senderFieldRow(
          pw.Text(
            sender.jobDescription,
            style: _senderTextStyle,
            textAlign: textAlignment,
          ),
        )
      : null;

  final addressField = _senderFieldRow(
    pw.Column(
      crossAxisAlignment: columnAlignment,
      mainAxisSize: pw.MainAxisSize.min,
      children: addressLines.map(_senderLine).toList(),
    ),
  );
  final phoneField =
      sender.phoneNumber.trim().isNotEmpty ? _senderFieldRow(_senderLine('Tel: ${sender.phoneNumber.trim()}')) : null;
  final emailField = sender.email.trim().isNotEmpty ? _senderFieldRow(_senderLine(sender.email.trim())) : null;
  final websiteField = sender.website.trim().isNotEmpty ? _senderFieldRow(_senderLine(sender.website.trim())) : null;
  final vatTaxIdField =
      sender.ustId.trim().isNotEmpty ? _senderFieldRow(_senderLine('USt-ID: ${sender.ustId.trim()}')) : null;

  // Add each field separately so you can reorder by moving lines.
  final result = <pw.Widget>[
    nameField,
    pw.SizedBox(height: 3),
    pw.Row(children: [
      pw.Expanded(child: pw.SizedBox.shrink()),
      pw.SizedBox(width: contentWidth, child: drawLine(height: 0.5, alignment: pw.Alignment.centerRight)),
    ]),
    pw.SizedBox(height: 3),
    if (jobDescriptionField != null) jobDescriptionField,
    addressField,
  ];
  result.add(pw.SizedBox(height: 8));
  if (phoneField != null) result.add(phoneField);
  if (emailField != null) result.add(emailField);
  if (websiteField != null) result.add(websiteField);
  result.add(pw.SizedBox(height: 4));
  if (vatTaxIdField != null) result.add(vatTaxIdField);
  return result;
}
