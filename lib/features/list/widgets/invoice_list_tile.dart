import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';
import 'package:invoice_manager/features/search/utils/search_highlight_spans.dart';

import 'invoice_list_payment_badge.dart';

class InvoiceListTile extends ConsumerWidget {
  const InvoiceListTile({
    super.key,
    required this.invoice,
    required this.onAction,
    required this.onTap,
    this.selected = false,
    this.highlightQuery = '',
  });

  final Invoice invoice;
  final ValueChanged<String> onAction;
  final VoidCallback onTap;
  final bool selected;

  /// Aktiver Suchtext; leer = keine Hervorhebung (case-insensitive Teilstrings).
  final String highlightQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = computeTotals(invoice);
    final clientLine = invoice.client.companyName.isNotEmpty ? invoice.client.companyName : invoice.client.name;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final firstItem = invoice.invoiceItemList.isNotEmpty ? invoice.invoiceItemList.first : null;
    final periodLabel = firstItem != null && firstItem.hasServicePeriod
        ? (firstItem.serviceDate != null
            ? dateFormat.format(firstItem.serviceDate!)
            : '${_monthName(firstItem.serviceMonth!)} ${firstItem.serviceYear}')
        : '-';

    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium ?? const TextStyle();
    final subtitleStyle = theme.textTheme.bodySmall ?? const TextStyle();
    final highlightStyle = titleStyle.copyWith(
      fontWeight: FontWeight.w600,
      backgroundColor: theme.colorScheme.secondaryContainer,
      color: theme.colorScheme.onSecondaryContainer,
    );
    final highlightSubtitleStyle = subtitleStyle.copyWith(
      fontWeight: FontWeight.w600,
      backgroundColor: theme.colorScheme.secondaryContainer,
      color: theme.colorScheme.onSecondaryContainer,
    );
    final paidStyle = theme.textTheme.bodySmall?.copyWith(fontSize: 12) ?? const TextStyle(fontSize: 12);
    final paidHighlightStyle = paidStyle.copyWith(
      fontWeight: FontWeight.w600,
      backgroundColor: theme.colorScheme.secondaryContainer,
      color: theme.colorScheme.onSecondaryContainer,
    );

    final nrPart = 'Nr. ${invoice.invoiceNumber} ·';
    final line1 = '${dateFormat.format(invoice.invoiceDate)} · $periodLabel';
    final line2 = formatCurrency(totals.gross);

    return ListTile(
      selected: selected,
      selectedTileColor: theme.colorScheme.surfaceContainerHighest,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              style: titleStyle,
              children: searchHighlightSpans(
                text: nrPart,
                query: highlightQuery,
                style: titleStyle,
                highlightStyle: highlightStyle,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: titleStyle,
                children: searchHighlightSpans(
                  text: clientLine,
                  query: highlightQuery,
                  style: titleStyle,
                  highlightStyle: highlightStyle,
                ),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              style: subtitleStyle,
              children: searchHighlightSpans(
                text: line1,
                query: highlightQuery,
                style: subtitleStyle,
                highlightStyle: highlightSubtitleStyle,
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              style: subtitleStyle,
              children: searchHighlightSpans(
                text: line2,
                query: highlightQuery,
                style: subtitleStyle,
                highlightStyle: highlightSubtitleStyle,
              ),
            ),
          ),
        ],
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
                  Text.rich(
                    TextSpan(
                      style: paidStyle,
                      children: searchHighlightSpans(
                        text: invoice.paidOn != null ? dateFormat.format(invoice.paidOn!) : '-',
                        query: highlightQuery,
                        style: paidStyle,
                        highlightStyle: paidHighlightStyle,
                      ),
                    ),
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
                value: 'preview',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined),
                    SizedBox(width: 8),
                    Text('Vorschau'),
                  ],
                ),
              ),
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
