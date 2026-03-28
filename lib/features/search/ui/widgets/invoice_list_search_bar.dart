import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:invoice_manager/features/form/ui/widgets/clearable_input_decoration.dart';
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
    ref.watch(invoiceListSearchQueryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        decoration: inputDecorationWithClear(
          controller: _controller,
          clearTooltip: 'Suche löschen',
          onAfterClear: () {
            ref.read(invoiceListSearchQueryProvider.notifier).state = '';
          },
          decoration: const InputDecoration(
            hintText: 'Alle Rechnungsdaten durchsuchen …',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        onChanged: (v) {
          ref.read(invoiceListSearchQueryProvider.notifier).state = v;
        },
      ),
    );
  }
}
