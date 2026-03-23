import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/sender.dart';
import 'package:invoice_manager/common/services/invoice_pdf_generator/config.dart';
import 'package:pdf/widgets.dart' as pw;

const pw.TextStyle _senderOneLineTextStyle = pw.TextStyle(
  fontSize: fontSizeXSmall,
  decoration: pw.TextDecoration.underline,
);

const pw.TextStyle _clientTextStyle = pw.TextStyle(
  fontSize: fontSizeMain,
);

List<pw.Widget> clientBlock(Client client, Sender sender) {
  final street = sender.address.streetNameAndNumber.trim();
  final postal = sender.address.postalCode != 0 ? sender.address.postalCode.toString() : '';
  final town = sender.address.town.trim();
  final postalTown = [postal, town].where((s) => s.isNotEmpty).join(' ');

  final addressSummary = postalTown.isNotEmpty
      ? (street.isNotEmpty ? '$street | $postalTown' : postalTown)
      : street;
  return [
    pw.Row(children: [
      pw.Text(
        '${sender.name} | $addressSummary ',
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
