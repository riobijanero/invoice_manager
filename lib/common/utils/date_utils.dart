import 'package:intl/intl.dart';
import 'package:invoice_manager/common/models/invoice.dart';

import 'invoice_calculations.dart';

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

final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

/// Formats a date as dd.MM.yyyy (German).
String formatDate(DateTime date) {
  return _dateFormat.format(date);
}
