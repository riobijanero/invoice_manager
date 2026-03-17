import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/sender.dart';
import 'package:invoice_manager/services/invoice_pdf_generator/config.dart';
import 'package:pdf/widgets.dart' as pw;

const pw.TextStyle _senderOneLineTextStyle = pw.TextStyle(
  fontSize: fontSizeXSmall,
  decoration: pw.TextDecoration.underline,
);

const pw.TextStyle _clientTextStyle = pw.TextStyle(
  fontSize: fontSizeMain,
);

List<pw.Widget> clientBlock(Client client, Sender sender) {
  return [
    pw.Row(children: [
      pw.Text(
        '${sender.name} | ${sender.address.split('\n').first} | ${sender.address.split('\n').skip(1).join('\n')} ',
        style: _senderOneLineTextStyle,
      ),
    ]),
    pw.SizedBox(height: 12),
    pw.Text(
      client.toBlockString(),
      style: _clientTextStyle,
    ),
  ];
}
