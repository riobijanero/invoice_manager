import 'package:invoice_manager/common/models/bank_details.dart';
import 'package:invoice_manager/common/services/utils.dart';
import 'package:pdf/widgets.dart' as pw;

/// Bank details table for the invoice PDF (Kontoinhaber, Geldinstitut, IBAN, BIC).
List<pw.Widget> bankDetailsBlock(BankDetails bankDetails) {
  final formattedIban = formatIbanForDisplay(bankDetails.iban);
  return [
    pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(90),
        1: const pw.FlexColumnWidth(1),
      },
      children: [
        tableRow('Kontoinhaber:', bankDetails.accountHolder),
        tableRow('Geldinstitut:', bankDetails.institution),
        tableRow('IBAN:', formattedIban),
        tableRow('BIC:', bankDetails.bic),
      ],
    ),
  ];
}
