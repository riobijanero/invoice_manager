// Filterlogik für die Rechnungssuche (Client-seitig über geladene Rechnungen).
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/features/search/utils/invoice_search_haystack.dart';
import 'package:invoice_manager/features/search/utils/search_query.dart';

/// `true`, wenn [query] nach Normalisierung in [buildInvoiceSearchHaystack] vorkommt (leer → immer true).
bool invoiceMatchesSearch(Invoice invoice, String query) {
  final q = normalizeInvoiceSearchQuery(query);
  if (q.isEmpty) return true;
  return buildInvoiceSearchHaystack(invoice).contains(q);
}

/// Teilmenge von [invoices] in gleicher Reihenfolge; leere [query] → unveränderte Liste.
List<Invoice> filterInvoicesBySearchQuery(List<Invoice> invoices, String query) {
  final q = normalizeInvoiceSearchQuery(query);
  if (q.isEmpty) return invoices;
  return invoices.where((i) => buildInvoiceSearchHaystack(i).contains(q)).toList();
}
