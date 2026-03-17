import 'package:intl/intl.dart';

final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

/// Formats a date as dd.MM.yyyy (German).
String formatDate(DateTime date) {
  return _dateFormat.format(date);
}
