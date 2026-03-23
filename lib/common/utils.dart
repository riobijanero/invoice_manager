import 'package:invoice_manager/common/models/invoice.dart';

import 'utils/invoice_calculations.dart';

/// Unpaid invoice whose due date (based on [`Invoice.dueDateType`]) is strictly
/// before today.
bool isOverdueUnpaid(Invoice invoice) {
  if (invoice.paidOn != null) return false;

  final due = computeDueDate(invoice);
  final dueDay = DateTime(due.year, due.month, due.day);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return dueDay.isBefore(today);
}

