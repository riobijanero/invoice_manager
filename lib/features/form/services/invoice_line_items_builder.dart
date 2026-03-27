// Parst Positionszeilen aus parallelen String-Listen (wie im Formular-State).
import 'package:invoice_manager/common/models/invoice_item.dart';

/// Baut [rowCount] [InvoiceItem]s; alle Listen müssen Länge ≥ [rowCount] haben.
///
/// Komma wird in Zahlfeldern wie im UI als Dezimaltrenner akzeptiert.
List<InvoiceItem> parseInvoiceLineItemsFromForm({
  required int rowCount,
  required List<bool> useServiceDate,
  required List<int?> serviceMonths,
  required List<int?> serviceYears,
  required List<DateTime?> serviceDates,
  required List<UnitType> unitTypes,
  required List<String> quantityTexts,
  required List<String> unitPriceTexts,
  required List<String> serviceDescriptions,
}) {
  return List<InvoiceItem>.generate(rowCount, (i) {
    final serviceDescription = serviceDescriptions[i].trim();
    final quantity = double.tryParse(quantityTexts[i].replaceFirst(',', '.')) ?? 0;
    final unitPrice = double.tryParse(unitPriceTexts[i].replaceFirst(',', '.')) ?? 0;
    return InvoiceItem(
      position: i + 1,
      serviceMonth: useServiceDate[i] ? null : serviceMonths[i],
      serviceYear: useServiceDate[i] ? null : serviceYears[i],
      serviceDate: useServiceDate[i] ? serviceDates[i] : null,
      unitType: unitTypes[i],
      quantity: quantity,
      unitPrice: unitPrice,
      serviceDescription: serviceDescription,
    );
  });
}
