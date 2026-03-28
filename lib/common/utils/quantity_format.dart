import 'package:intl/intl.dart';

/// No thousands separators; variable fractional digits (no trailing zeros).
final NumberFormat _quantityDe = NumberFormat('#0.##########', 'de_DE');

/// German-style quantity (Anzahl) for forms and PDF: no unnecessary decimals
/// (`3` not `3,0`), no right-padding (`3,5` not `3,50`).
String formatQuantityForDisplay(double value) {
  return _quantityDe.format(value);
}
