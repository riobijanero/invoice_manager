import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/invoice.dart';
import '../../providers/providers.dart';
import '../../routing/app_router.dart';
import '../../utils/currency_format.dart';
import '../../utils/invoice_calculations.dart';

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncInvoices = ref.watch(invoiceListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechnungsliste'),
      ),
      body: asyncInvoices.when(
        data: (invoices) {
          if (invoices.isEmpty) {
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
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              final totals = computeTotals(invoice);
              final clientLine = invoice.client.name.isNotEmpty
                  ? invoice.client.name
                  : _firstLine(invoice.client.address);
              final dateFormat = DateFormat('dd.MM.yyyy');
              final periodLabel =
                  '${_monthName(invoice.serviceMonth)} ${invoice.serviceYear}';
              return ListTile(
                title: Text('Nr. ${invoice.invoiceNumber} · $clientLine'),
                subtitle: Text(
                  '${dateFormat.format(invoice.invoiceDate)} · $periodLabel · ${formatCurrency(totals.gross)}',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) =>
                      _handleAction(context, ref, value, invoice),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy),
                          SizedBox(width: 8),
                          Text('Duplizieren'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Löschen'),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => context.push(pathEdit(invoice.id)),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/invoice/new'),
        icon: const Icon(Icons.add),
        label: const Text('Neue Rechnung'),
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
    final newInvoice = invoice.copyWith(
      id: _generateId(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      invoiceNumber: '${invoice.invoiceNumber}-Kopie',
    );
    await repo.save(newInvoice);
    ref.invalidate(invoiceListProvider);
    if (context.mounted) {
      context.push(pathEdit(newInvoice.id));
    }
  }

  String _generateId() {
    // Simple UUID-like id without adding uuid package call in this file
    return '${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecond}';
  }
}

String _firstLine(String text) {
  final lines = text.split(RegExp(r'[\r\n]+'));
  if (lines.isEmpty) return text.trim();
  return lines.first.trim();
}

String _monthName(int month) {
  const names = [
    'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
    'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
  ];
  if (month < 1 || month > 12) return '$month';
  return names[month - 1];
}
