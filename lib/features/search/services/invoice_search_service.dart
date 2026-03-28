// Filterlogik für die Rechnungssuche (Client-seitig über geladene Rechnungen).
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/features/form/utils/client_dedupe_utils.dart';
import 'package:invoice_manager/features/form/utils/service_preset_dedupe_utils.dart';
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

/// Suchtext + optional Kunde + optional gespeicherte Leistung (Position passt Schlüssel).
List<Invoice> applyInvoiceListFilters(
  List<Invoice> invoices, {
  required String searchQuery,
  String? clientKey,
  String? servicePresetKey,
}) {
  var list = filterInvoicesBySearchQuery(invoices, searchQuery);
  final ck = clientKey?.trim();
  if (ck != null && ck.isNotEmpty) {
    list = list.where((i) => clientDedupeKey(i.client) == ck).toList();
  }
  final sk = servicePresetKey?.trim();
  if (sk != null && sk.isNotEmpty) {
    list = list
        .where(
          (inv) => inv.invoiceItemList.any(
            (line) => invoiceLineServicePresetKey(line) == sk,
          ),
        )
        .toList();
  }
  return list;
}
