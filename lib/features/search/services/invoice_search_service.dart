import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/features/search/utils/invoice_search_haystack.dart';
import 'package:invoice_manager/features/search/utils/search_query.dart';

bool invoiceMatchesSearch(Invoice invoice, String query) {
  final q = normalizeInvoiceSearchQuery(query);
  if (q.isEmpty) return true;
  return buildInvoiceSearchHaystack(invoice).contains(q);
}

/// Preserves sort order of the input list.
List<Invoice> filterInvoicesBySearchQuery(List<Invoice> invoices, String query) {
  final q = normalizeInvoiceSearchQuery(query);
  if (q.isEmpty) return invoices;
  return invoices.where((i) => buildInvoiceSearchHaystack(i).contains(q)).toList();
}
