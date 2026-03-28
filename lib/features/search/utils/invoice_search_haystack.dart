// Baut einen durchsuchbaren Text aus allen Feldern einer [Invoice] (für die Liste).
import 'package:intl/intl.dart';

import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
import 'package:invoice_manager/common/utils/quantity_format.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';

String _formatDatesForSearch(DateTime d) =>
    '${d.toIso8601String()} ${DateFormat('dd.MM.yyyy').format(d)}';

void _bufAppend(StringBuffer b, String? s) {
  if (s == null) return;
  final t = s.trim();
  if (t.isEmpty) return;
  b.write(' ');
  b.write(t.toLowerCase());
}

void _bufAppendDate(StringBuffer b, DateTime? d) {
  if (d == null) return;
  _bufAppend(b, _formatDatesForSearch(d));
}

/// Zwei-Dezimal-Schreibweisen (Punkt und Komma) für Betragssuche ohne Tausenderpunkt.
void _bufAppendAmountFixed(StringBuffer b, double x) {
  if (x.isNaN || x.isInfinite) return;
  final f = x.toStringAsFixed(2);
  _bufAppend(b, f);
  _bufAppend(b, f.replaceAll('.', ','));
}

/// Rechnungs-Summen aus [computeTotals]: Zwischensumme, Rabatt, Netto, MwSt-Betrag, **Brutto**.
///
/// Zusätzlich [formatCurrency] für den Bruttobetrag (z. B. `1.234,56 €`), wie in der App/PDF.
void _bufAppendInvoiceTotals(StringBuffer b, Invoice invoice) {
  final t = computeTotals(invoice);
  _bufAppendAmountFixed(b, t.subtotal);
  _bufAppendAmountFixed(b, t.discountAmount);
  _bufAppendAmountFixed(b, t.net);
  _bufAppendAmountFixed(b, t.vat);
  _bufAppendAmountFixed(b, t.gross);
  _bufAppend(b, formatCurrency(t.gross));
}

/// Ein einziger lowercased String mit allen durchsuchbaren Inhalten (inkl. Datums-ISO, `dd.MM.yyyy`, Beträge).
String buildInvoiceSearchHaystack(Invoice invoice) {
  final b = StringBuffer();
  _bufAppend(b, invoice.id);
  _bufAppend(b, invoice.invoiceNumber);
  _bufAppend(b, invoice.contractNumber);
  _bufAppendDate(b, invoice.createdAt);
  _bufAppendDate(b, invoice.updatedAt);
  _bufAppendDate(b, invoice.invoiceDate);
  _bufAppendDate(b, invoice.paidOn);
  _bufAppendDate(b, invoice.customDueDate);
  _bufAppend(b, invoice.introductoryText);
  _bufAppend(b, invoice.discountType.displayName);
  _bufAppend(b, invoice.discountValue.toString());
  _bufAppend(b, invoice.vat.toString());
  _bufAppend(b, invoice.dueDateType.displayName);
  if (invoice.hasQrCode) _bufAppend(b, 'qr-code');

  final s = invoice.sender;
  _bufAppend(b, s.name);
  _bufAppend(b, s.jobDescription);
  _bufAppend(b, s.address.streetNameAndNumber);
  _bufAppend(b, s.address.postalCode != 0 ? s.address.postalCode.toString() : null);
  _bufAppend(b, s.address.town);
  _bufAppend(b, s.address.country);
  _bufAppend(b, s.phoneNumber);
  _bufAppend(b, s.email);
  _bufAppend(b, s.website);
  _bufAppend(b, s.ustId);
  _bufAppend(b, s.taxNumber);

  final c = invoice.client;
  _bufAppend(b, c.clientId);
  _bufAppend(b, c.companyName);
  _bufAppend(b, c.name);
  _bufAppend(b, c.address.streetNameAndNumber);
  _bufAppend(b, c.address.postalCode != 0 ? c.address.postalCode.toString() : null);
  _bufAppend(b, c.address.town);
  _bufAppend(b, c.address.country);

  final bk = invoice.bankDetails;
  _bufAppend(b, bk.accountHolder);
  _bufAppend(b, bk.institution);
  _bufAppend(b, bk.iban);
  _bufAppend(b, bk.bic);

  for (final item in invoice.invoiceItemList) {
    _bufAppend(b, item.position.toString());
    _bufAppend(b, item.serviceDescription);
    if (item.serviceMonth != null) _bufAppend(b, item.serviceMonth.toString());
    if (item.serviceYear != null) _bufAppend(b, item.serviceYear.toString());
    _bufAppendDate(b, item.serviceDate);
    _bufAppend(b, item.unitType.name);
    _bufAppend(b, item.unitLabel);
    _bufAppend(b, formatQuantityForDisplay(item.quantity));
    _bufAppend(b, item.quantity.toString());
    _bufAppend(b, item.unitPrice.toString());
  }

  _bufAppendInvoiceTotals(b, invoice);

  return b.toString();
}
