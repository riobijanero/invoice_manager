import 'package:flutter/material.dart';

import 'package:invoice_manager/common/layout/invoice_layout_breakpoints.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';

/// Paid ([Icons.check_circle]) or overdue indicator for [InvoiceListTile].
///
/// On wide (split) layout: red [Icons.error_outline] with tooltip.
/// On narrow layout: red „überfällig“ [Chip].
/// Returns [SizedBox.shrink] when unpaid and not overdue.
class InvoiceListPaymentBadge extends StatelessWidget {
  const InvoiceListPaymentBadge({
    super.key,
    required this.invoice,
  });

  final Invoice invoice;

  /// Unpaid and calendar due date strictly before today.
  static bool isOverdueUnpaid(Invoice invoice) {
    if (invoice.paidOn != null) return false;
    final due = computeDueDate(invoice);
    final dueDay = DateTime(due.year, due.month, due.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return dueDay.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    final paid = invoice.paidOn != null;
    final overdue = isOverdueUnpaid(invoice);
    if (!paid && !overdue) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final wide = isWideInvoiceLayout(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 4),
        if (paid)
          const Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green,
          )
        else if (wide)
          Tooltip(
            message: 'überfällig',
            child: Icon(
              Icons.error_outline,
              size: 18,
              semanticLabel: 'überfällig',
              color: theme.colorScheme.error,
            ),
          )
        else
          Chip(
            label: const Text('überfällig'),
            labelStyle: const TextStyle(
              fontSize: 10,
              height: 1.1,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: theme.colorScheme.error,
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      ],
    );
  }
}
