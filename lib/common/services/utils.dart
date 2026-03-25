import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'invoice_pdf_generator/config.dart';

String formatIbanForDisplay(String input) {
  final raw = input.replaceAll(' ', '').trim().toUpperCase();
  if (raw.isEmpty) return '';
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && i % 4 == 0) buffer.write(' ');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}

String firstLine(String multiline) {
  final lines = multiline.split(RegExp(r'[\r\n]+'));
  if (lines.isEmpty) return multiline.trim();
  return lines.first.trim();
}

/// Returns the text without the first [lines] lines (e.g. to display an
/// address block without its heading line). If the input has fewer or equal
/// lines than [lines], an empty string is returned.
String diplayWithoutFirst(
  String multiline, {
  required int lines,
}) {
  final parts = multiline.split(RegExp(r'[\r\n]+'));
  if (parts.length <= lines) {
    return '';
  }
  return parts.skip(lines).join('\n').trimLeft();
}

pw.Widget cell(String text, {bool bold = false, bool alignRight = false}) {
  final child = pw.Text(
    text,
    textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
    style: pw.TextStyle(
      fontSize: fontSizeSmall,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    ),
  );
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 6),
    child: alignRight
        ? pw.Align(
            alignment: pw.Alignment.centerRight,
            child: child,
          )
        : child,
  );
}

pw.TableRow tableRow(String label, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.only(right: 4, top: 0.5, bottom: 0.5),
        child: pw.Text(label, style: const pw.TextStyle(fontSize: fontSizeMain)),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 0.5, bottom: 0.5),
        child: pw.Text(value, style: const pw.TextStyle(fontSize: fontSizeMain)),
      ),
    ],
  );
}

pw.Container drawLine({double? height, double? width, pw.Alignment? alignment}) {
  return pw.Container(
    alignment: alignment,
    height: height ?? 0.5,
    width: width,
    color: PdfColors.grey800,
  );
}

/// Small text style (fontSize 9) for shared use in PDF layout.
const pw.TextStyle pdfSmallTextStyle = pw.TextStyle(fontSize: fontSizeSmall);

/// A single line of text with small style and right alignment, for use in
/// header blocks (e.g. sender, client).
pw.Widget pdfSmallRightAlignedLine(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 1),
    child: pw.Text(
      text,
      style: pdfSmallTextStyle,
      textAlign: pw.TextAlign.right,
    ),
  );
}

/// A row that places [content] in a right-aligned column of [width] pt.
/// Reusable for sender block, client block, or other header sections.
pw.Widget pdfRightAlignedRow(pw.Widget content, {double width = 220}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.end,
    children: [
      pw.Expanded(child: pw.SizedBox.shrink()),
      pw.SizedBox(
        width: width,
        child: pw.Align(
          alignment: pw.Alignment.centerRight,
          child: content,
        ),
      ),
    ],
  );
}
