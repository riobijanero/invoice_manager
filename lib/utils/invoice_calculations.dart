import '../models/discount_type.dart';
import '../models/due_date_type.dart';
import '../models/invoice.dart';

/// Computed values for an invoice (subtotal, discount, net, VAT, gross).
class InvoiceTotals {
  const InvoiceTotals({
    required this.subtotal,
    required this.discountAmount,
    required this.net,
    required this.vat,
    required this.gross,
  });

  final double subtotal;
  final double discountAmount;
  final double net;
  final double vat;
  final double gross;

  static const double vatRate = 0.19;
}

InvoiceTotals computeTotals(Invoice invoice) {
  final subtotal = invoice.hours * invoice.hourlyRate;
  final discountAmount = invoice.discountType == DiscountType.percent
      ? subtotal * (invoice.discountValue / 100)
      : invoice.discountValue;
  final net = (subtotal - discountAmount).clamp(0.0, double.infinity);
  final vat = net * InvoiceTotals.vatRate;
  final gross = net + vat;
  return InvoiceTotals(
    subtotal: subtotal,
    discountAmount: discountAmount,
    net: net,
    vat: vat,
    gross: gross,
  );
}

/// First day of the given month/year.
DateTime periodStart(int month, int year) {
  return DateTime(year, month, 1);
}

/// Last day of the given month/year.
DateTime periodEnd(int month, int year) {
  return DateTime(year, month + 1, 0);
}

/// Due date from invoice (based on dueDateType and invoiceDate/customDueDate).
DateTime computeDueDate(Invoice invoice) {
  switch (invoice.dueDateType) {
    case DueDateType.twoWeeks:
      return invoice.invoiceDate.add(const Duration(days: 14));
    case DueDateType.thirtyDays:
      return invoice.invoiceDate.add(const Duration(days: 30));
    case DueDateType.custom:
      return invoice.customDueDate ?? invoice.invoiceDate.add(const Duration(days: 14));
  }
}
