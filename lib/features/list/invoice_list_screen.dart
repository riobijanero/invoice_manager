import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:invoice_manager/common/layout/invoice_layout_breakpoints.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:invoice_manager/features/exportData/services/csv_export_service.dart';
import 'package:invoice_manager/features/exportData/services/csv_import_service.dart';
import 'package:invoice_manager/features/form/utils/utils.dart';
import 'package:invoice_manager/features/list/widgets/invoice_list_tile.dart';
import 'package:invoice_manager/features/list/widgets/new_invoice_draft_list_tile.dart';
import '../../routing/app_router.dart';

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncInvoices = ref.watch(invoiceListProvider);
    final selectedId = _selectedInvoiceId(context);
    final wide = isWideInvoiceLayout(context);
    final showNewDraftRow = wide && GoRouterState.of(context).uri.path == '/invoice/new';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechnungsliste'),
      ),
      body: asyncInvoices.when(
        data: (invoices) {
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
          final itemCount = invoices.length + (showNewDraftRow ? 1 : 0);
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (showNewDraftRow && index == 0) {
                return NewInvoiceDraftListTile(
                  onTap: () => context.go('/invoice/new'),
                );
              }
              final invoiceIndex = showNewDraftRow ? index - 1 : index;
              final invoice = invoices[invoiceIndex];
              return InvoiceListTile(
                invoice: invoice,
                selected: selectedId == invoice.id,
                onAction: (action) => _handleAction(context, ref, action, invoice),
                onTap: () => wide ? context.go(pathEdit(invoice.id)) : context.push(pathEdit(invoice.id)),
              );
            },
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
              SizedBox(width: 30),
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
        context.go(pathEdit(newInvoice.id));
      } else {
        context.push(pathEdit(newInvoice.id));
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
