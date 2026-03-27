import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:invoice_manager/features/search/providers/invoice_list_search_query_provider.dart';

/// Suchfeld oberhalb der Rechnungsliste; synchronisiert mit [invoiceListSearchQueryProvider].
class InvoiceListSearchBar extends ConsumerStatefulWidget {
  const InvoiceListSearchBar({super.key});

  @override
  ConsumerState<InvoiceListSearchBar> createState() => _InvoiceListSearchBarState();
}

class _InvoiceListSearchBarState extends ConsumerState<InvoiceListSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(invoiceListSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(invoiceListSearchQueryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Alle Rechnungsdaten durchsuchen …',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: searchQuery.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Suche löschen',
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    ref.read(invoiceListSearchQueryProvider.notifier).state = '';
                  },
                ),
        ),
        onChanged: (v) {
          ref.read(invoiceListSearchQueryProvider.notifier).state = v;
        },
      ),
    );
  }
}
