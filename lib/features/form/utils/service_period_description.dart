// Platzhalter und Text-Ersetzung für Leistungszeitraum in Positionsbeschreibungen
// (`{PERIOD}` und bestehende Datumsbereiche im deutschen Format).
import 'package:intl/intl.dart';

/// Ersetzt `{PERIOD}` bzw. `dd.MM.yyyy - dd.MM.yyyy` durch [newPeriod]. Gibt [text] zurück, wenn nichts passt.
String replaceServicePeriodInDescription(String text, String newPeriod) {
  if (text.contains('{PERIOD}')) {
    return text.replaceAll('{PERIOD}', newPeriod);
  }
  final periodPattern = RegExp(r'\d{2}\.\d{2}\.\d{4}\s*-\s*\d{2}\.\d{2}\.\d{4}');
  if (periodPattern.hasMatch(text)) {
    return text.replaceFirst(periodPattern, newPeriod);
  }
  return text;
}

/// Kalendermonat als Textspanne erster–letzter Tag (`dd.MM.yyyy - dd.MM.yyyy`).
String periodPlaceholderForMonthYear(int month, int year) {
  final start = DateTime(year, month, 1);
  final end = DateTime(year, month + 1, 0);
  final fmt = DateFormat('dd.MM.yyyy');
  return '${fmt.format(start)} - ${fmt.format(end)}';
}

/// Einzeltag im Format `dd.MM.yyyy` (Leistungsdatum-Modus).
String serviceDatePlaceholder(DateTime d) {
  final fmt = DateFormat('dd.MM.yyyy');
  return fmt.format(d);
}

/// `true`, wenn für die Zeile entweder ein Leistungsdatum oder Monat+Jahr gewählt ist.
bool hasSelectedServicePeriod({
  required bool useServiceDate,
  required DateTime? serviceDate,
  required int? serviceMonth,
  required int? serviceYear,
}) {
  if (useServiceDate) {
    return serviceDate != null;
  }
  return serviceMonth != null && serviceYear != null;
}

