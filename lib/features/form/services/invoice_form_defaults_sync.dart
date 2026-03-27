// Schreibt Formular-Snapshot in [InvoiceDefaults] (letzte Rechnungsnr., Stammdaten, …).
import 'package:invoice_manager/common/models/bank_details.dart';
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/models/sender.dart';
import 'package:invoice_manager/repositories/defaults_repository.dart';

/// Hourly rate taken from the first row that uses [UnitType.hours].
double hourlyRateFromUnitTypeRow({
  required List<UnitType> unitTypes,
  required List<String> unitPriceFieldTexts,
}) {
  final hourlyIndex = unitTypes.indexOf(UnitType.hours);
  if (hourlyIndex >= 0 && hourlyIndex < unitPriceFieldTexts.length) {
    return double.tryParse(
          unitPriceFieldTexts[hourlyIndex].replaceFirst(',', '.'),
        ) ??
        0.0;
  }
  return 0.0;
}

/// Lädt aktuelle Defaults, merged Sender/Kunde/Bank/Rabatt/Fälligkeit/Stundensatz und speichert.
///
/// [lastInvoiceNumber] wird nur überschrieben, wenn [isNewInvoice] true ist.
Future<void> persistInvoiceDefaultsFromForm({
  required DefaultsRepository defaultsRepo,
  required bool isNewInvoice,
  required String invoiceNumber,
  required Sender sender,
  required Client client,
  required String contractNumber,
  required BankDetails bankDetails,
  required String ustId,
  required double hourlyRate,
  required DiscountType discountType,
  required double discountValue,
  required DueDateType dueDateType,
}) async {
  final current = await defaultsRepo.load();
  await defaultsRepo.save(
    current.copyWith(
      lastInvoiceNumber: isNewInvoice ? invoiceNumber.trim() : current.lastInvoiceNumber,
      sender: sender,
      client: client,
      contractNumber: contractNumber.trim(),
      bankDetails: bankDetails,
      ustId: ustId.trim(),
      hourlyRate: hourlyRate,
      discountType: discountType,
      discountValue: discountValue,
      dueDateType: dueDateType,
    ),
  );
}
