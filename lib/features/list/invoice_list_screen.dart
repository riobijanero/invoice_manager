import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:invoice_manager/common/layout/invoice_layout_breakpoints.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_defaults.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:invoice_manager/features/exportData/services/csv_export_service.dart';
import 'package:invoice_manager/features/exportData/services/csv_import_service.dart';
import 'package:invoice_manager/features/form/utils/utils.dart';
import 'package:invoice_manager/features/list/widgets/invoice_list_tile.dart';
import 'package:invoice_manager/features/list/widgets/new_invoice_draft_list_tile.dart';
import 'package:invoice_manager/features/search/providers/invoice_list_search_query_provider.dart';
import 'package:invoice_manager/features/search/services/invoice_search_service.dart';
import 'package:invoice_manager/features/search/ui/widgets/invoice_list_search_bar.dart';
import '../../routing/app_router.dart';

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncInvoices = ref.watch(invoiceListProvider);
    final searchQuery = ref.watch(invoiceListSearchQueryProvider);
    final selectedId = _selectedInvoiceId(context);
    final wide = isWideInvoiceLayout(context);
    final showNewDraftRow = wide && GoRouterState.of(context).uri.path == '/invoice/new';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechnungsliste'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menü',
            onSelected: (v) async {
              if (v == 'reset_data') {
                await _confirmResetAllData(context, ref);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'reset_data',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever_outlined),
                    SizedBox(width: 8),
                    Text('Alle Daten löschen'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: asyncInvoices.when(
        data: (invoices) {
          final filtered = filterInvoicesBySearchQuery(invoices, searchQuery);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const InvoiceListSearchBar(),
              Expanded(
                child: _invoiceListBody(
                  context,
                  ref,
                  invoices: invoices,
                  filtered: filtered,
                  searchQuery: searchQuery,
                  showNewDraftRow: showNewDraftRow,
                  selectedId: selectedId,
                  wide: wide,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Fehler: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(invoiceListProvider),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              FloatingActionButton(
                tooltip: 'Rechnungen importieren',
                heroTag: 'import_data_fab',
                onPressed: () => CsvImportService.importIntoRepository(
                  context: context,
                  repository: ref.read(invoiceRepositoryProvider),
                  onDataChanged: () => ref.invalidate(invoiceListProvider),
                ),
                child: const Icon(Icons.upload_file_outlined),
              ),
              const SizedBox(width: 12),
              FloatingActionButton(
                tooltip: 'Rechnungen exportieren',
                heroTag: 'export_data_fab',
                onPressed: () => CsvExportService.exportFromRepository(
                  context: context,
                  repository: ref.read(invoiceRepositoryProvider),
                ),
                child: const Icon(Icons.download_outlined),
              ),
            ],
          ),
          FloatingActionButton.extended(
            heroTag: 'new_invoice_fab',
            onPressed: () => context.go('/invoice/new'),
            icon: const Icon(Icons.add),
            label: const Text('Neue Rechnung'),
          ),
        ],
      ),
    );
  }

  Widget _invoiceListBody(
    BuildContext context,
    WidgetRef ref, {
    required List<Invoice> invoices,
    required List<Invoice> filtered,
    required String searchQuery,
    required bool showNewDraftRow,
    required String? selectedId,
    required bool wide,
  }) {
    if (invoices.isEmpty && !showNewDraftRow) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 64),
            const SizedBox(height: 16),
            const Text('Noch keine Rechnungen'),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => context.go('/invoice/new'),
              icon: const Icon(Icons.add),
              label: const Text('Neue Rechnung'),
            ),
          ],
        ),
      );
    }

    final queryTrimmed = searchQuery.trim();
    final hasNoMatches = filtered.isEmpty && queryTrimmed.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (showNewDraftRow)
          NewInvoiceDraftListTile(
            onTap: () => context.go('/invoice/new'),
          ),
        if (hasNoMatches)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Keine Treffer für „$queryTrimmed“',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          )
        else
          ...filtered.map(
            (invoice) => InvoiceListTile(
              invoice: invoice,
              highlightQuery: searchQuery,
              selected: selectedId == invoice.id,
              onAction: (action) => _handleAction(context, ref, action, invoice),
              onTap: () => wide ? context.go(pathEdit(invoice.id)) : context.push(pathEdit(invoice.id)),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmResetAllData(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alle Daten löschen?'),
        content: const Text(
          'Dies löscht alle gespeicherten Rechnungen und setzt die Standardwerte zurück.\n\n'
          'Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(invoiceRepositoryProvider).replaceAll(const []);
      await ref.read(defaultsRepositoryProvider).save(
            const InvoiceDefaults(serviceDescriptionTemplate: defaultServiceDescriptionTemplate),
          );
      ref.invalidate(invoiceListProvider);
      ref.invalidate(defaultsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alle Daten wurden gelöscht.')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Löschen fehlgeschlagen: $e')),
      );
    }
  }

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    Invoice invoice,
  ) {
    if (action == 'delete') {
      _confirmDelete(context, ref, invoice);
    } else if (action == 'duplicate') {
      _duplicateInvoice(context, ref, invoice);
    } else if (action == 'preview') {
      _openPreview(context, invoice);
    }
  }

  void _openPreview(BuildContext context, Invoice invoice) {
    if (isWideInvoiceLayout(context)) {
      context.go(pathPreview(invoice.id));
    } else {
      context.push(pathPreview(invoice.id));
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Invoice invoice,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechnung löschen'),
        content: Text(
          'Rechnung Nr. ${invoice.invoiceNumber} wirklich löschen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await ref.read(invoiceRepositoryProvider).delete(invoice.id);
      ref.invalidate(invoiceListProvider);
    }
  }

  Future<void> _duplicateInvoice(
    BuildContext context,
    WidgetRef ref,
    Invoice invoice,
  ) async {
    final repo = ref.read(invoiceRepositoryProvider);
    final defaultsRepo = ref.read(defaultsRepositoryProvider);
    final d = await defaultsRepo.load();
    final newNumber = nextInvoiceNumber(d.lastInvoiceNumber);
    final newInvoice = invoice.copyWith(
      id: _generateId(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      invoiceNumber: newNumber,
    );
    await repo.save(newInvoice);
    await defaultsRepo.save(d.copyWith(lastInvoiceNumber: newNumber));
    ref.invalidate(invoiceListProvider);
    ref.invalidate(defaultsProvider);
    if (context.mounted) {
      if (isWideInvoiceLayout(context)) {
        context.go('${pathEdit(newInvoice.id)}?source=duplicate');
      } else {
        context.push('${pathEdit(newInvoice.id)}?source=duplicate');
      }
    }
  }

  /// Current invoice id from the URL when viewing form or preview (wide layout selection).
  String? _selectedInvoiceId(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (path == '/invoice/new') return null;
    final preview = RegExp(r'^/invoice/([^/]+)/preview$').firstMatch(path);
    if (preview != null) return preview.group(1);
    final edit = RegExp(r'^/invoice/([^/]+)$').firstMatch(path);
    if (edit != null) {
      final id = edit.group(1)!;
      if (id != 'new') return id;
    }
    return null;
  }

  String _generateId() {
    // Simple UUID-like id without adding uuid package call in this file
    return '${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecond}';
  }
}
