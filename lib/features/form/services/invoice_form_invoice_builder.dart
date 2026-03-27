// Zusammenbau und Validierung der zu speichernden [Invoice] aus Formular-Daten.
import 'package:uuid/uuid.dart';

import 'package:invoice_manager/common/models/bank_details.dart';
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/models/sender.dart';

/// Erzeugt die persistierbare [Invoice] oder einen Fehlertext.
///
/// - [routeInvoiceId]: `null` bei neuer Rechnung → neue UUID, sonst bestehende ID.
/// - [loadedInvoice]: für `createdAt`-Erhalt beim Bearbeiten (gleiche ID).
/// - Rabatt: bei Überschreiten der Zwischensumme `(null, Fehlermeldung)`.
(Invoice?, String?) buildStoredInvoice({
  required String? routeInvoiceId,
  required Invoice? loadedInvoice,
  required String invoiceNumber,
  required DateTime invoiceDate,
  required DateTime? paidOn,
  required Sender sender,
  required Client client,
  required String contractNumber,
  required BankDetails bankDetails,
  required List<InvoiceItem> items,
  required DiscountType discountType,
  required double discountValue,
  required double vat,
  required DueDateType dueDateType,
  required bool hasQrCode,
  required DateTime? customDueDate,
  required String introductoryText,
}) {
  final subtotal = items.fold<double>(0.0, (sum, item) => sum + item.itemTotal);
  final discountAmount =
      discountType == DiscountType.percent ? subtotal * (discountValue / 100) : discountValue;
  if (discountAmount > subtotal) {
    return (null, 'Rabatt darf den Zwischensummenbetrag nicht übersteigen.');
  }

  final id = routeInvoiceId ?? loadedInvoice?.id ?? const Uuid().v4();
  final haveLoadedSnapshot = loadedInvoice != null && loadedInvoice.id == id;
  final createdAt = haveLoadedSnapshot ? loadedInvoice.createdAt : DateTime.now();

  final invoice = Invoice(
    id: id,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
    invoiceNumber: invoiceNumber.trim(),
    sender: sender,
    client: client,
    contractNumber: contractNumber.trim(),
    bankDetails: bankDetails,
    invoiceDate: invoiceDate,
    paidOn: paidOn,
    invoiceItemList: items,
    discountType: discountType,
    discountValue: discountValue,
    vat: vat,
    dueDateType: dueDateType,
    hasQrCode: hasQrCode,
    customDueDate: dueDateType == DueDateType.custom ? customDueDate : null,
    introductoryText: introductoryText.trim(),
  );
  return (invoice, null);
}
