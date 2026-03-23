import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';

import 'invoice_list_payment_badge.dart';

class InvoiceListTile extends ConsumerWidget {
  const InvoiceListTile({
    super.key,
    required this.invoice,
    required this.onAction,
    required this.onTap,
    this.selected = false,
  });

  final Invoice invoice;
  final ValueChanged<String> onAction;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = computeTotals(invoice);
    final clientLine = invoice.client.name.isNotEmpty
        ? invoice.client.name
        : (invoice.client.address.streetNameAndNumber.isNotEmpty
            ? invoice.client.address.streetNameAndNumber
            : (invoice.client.address.postalCode != 0
                ? invoice.client.address.postalCode.toString()
                : invoice.client.address.town));
    final dateFormat = DateFormat('dd.MM.yyyy');
    final firstItem = invoice.invoiceItemList.isNotEmpty ? invoice.invoiceItemList.first : null;
    final periodLabel = firstItem != null && firstItem.hasServicePeriod
        ? '${_monthName(firstItem.serviceMonth!)} ${firstItem.serviceYear}'
        : '-';

    final theme = Theme.of(context);
    return ListTile(
      selected: selected,
      selectedTileColor: theme.colorScheme.surfaceContainerHighest,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Nr. ${invoice.invoiceNumber} ·',
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              clientLine,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // InvoiceListPaymentBadge(invoice: invoice),
        ],
      ),
      subtitle: Text(
        '${dateFormat.format(invoice.invoiceDate)} · $periodLabel\n${formatCurrency(totals.gross)}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final initial = invoice.paidOn ?? invoice.invoiceDate;
              final date = await showDatePicker(
                context: context,
                initialDate: initial,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date == null) return;
              await ref.read(invoiceRepositoryProvider).save(invoice.copyWith(paidOn: date));
              ref.invalidate(invoiceListProvider);
              ref.invalidate(invoiceDetailProvider(invoice.id));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Bezahlt am',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    invoice.paidOn != null ? dateFormat.format(invoice.paidOn!) : '-',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Reserve space so the popup button doesn't shift when the badge is hidden.
          SizedBox(
            width: 24,
            child: InvoiceListPaymentBadge(invoice: invoice),
          ),
          PopupMenuButton<String>(
            onSelected: onAction,
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
        ],
      ),
      onTap: onTap,
    );
  }
}

String _firstLine(String text) {
  final lines = text.split(RegExp(r'[\r\n]+'));
  if (lines.isEmpty) return text.trim();
  return lines.first.trim();
}

String _monthName(int month) {
  const names = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];
  if (month < 1 || month > 12) return '$month';
  return names[month - 1];
}
