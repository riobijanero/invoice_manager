import 'package:flutter/material.dart';

import 'package:invoice_manager/common/utils/date_utils.dart';
import 'package:invoice_manager/common/models/invoice.dart';

/// Paid ([Icons.check_circle]) or overdue indicator for [InvoiceListTile].
///
/// On overdue (unpaid): red [Icons.error_outline] with tooltip.
/// Returns [SizedBox.shrink] when unpaid and not overdue.
class InvoiceListPaymentBadge extends StatelessWidget {
  const InvoiceListPaymentBadge({
    super.key,
    required this.invoice,
  });

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final paid = invoice.paidOn != null;
    final overdue = isOverdueUnpaid(invoice);
    if (!paid && !overdue) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 4),
        if (paid)
          const Icon(
            Icons.check_circle_outline,
            size: 18,
            color: Colors.green,
          )
        else
          Tooltip(
            message: 'überfällig',
            child: Icon(
              Icons.error_outline,
              size: 18,
              semanticLabel: 'überfällig',
              color: theme.colorScheme.error,
            ),
          ),
      ],
    );
  }
}
