import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';

class InvoiceListTile extends ConsumerWidget {
  const InvoiceListTile({
    super.key,
    required this.invoice,
    required this.onAction,
    required this.onTap,
  });

  final Invoice invoice;
  final ValueChanged<String> onAction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = computeTotals(invoice);
    final clientLine = invoice.client.name.isNotEmpty ? invoice.client.name : _firstLine(invoice.client.address);
    final dateFormat = DateFormat('dd.MM.yyyy');
    final periodLabel =
        '${_monthName(invoice.invoiceItem.serviceMonth)} ${invoice.invoiceItem.serviceYear}';

    return ListTile(
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
          if (invoice.paidOn != null) const SizedBox(width: 4),
          if (invoice.paidOn != null)
            const Icon(
              Icons.check_circle,
              size: 16,
              color: Colors.green,
            ),
        ],
      ),
      subtitle: Text(
        '${dateFormat.format(invoice.invoiceDate)} · $periodLabel · ${formatCurrency(totals.gross)}',
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
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'bezahlt am',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    invoice.paidOn != null ? dateFormat.format(invoice.paidOn!) : '-',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
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
