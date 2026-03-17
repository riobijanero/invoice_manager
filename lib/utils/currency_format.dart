import 'package:intl/intl.dart';

final NumberFormat _currencyFormat = NumberFormat.currency(
  locale: 'de_DE',
  symbol: '€',
  decimalDigits: 2,
);

/// Formats a number as German-style number + currency symbol (e.g. 1.234,56 EUR).
String formatCurrency(double value) {
  return _currencyFormat.format(value);
}

String appendCurrencySymbol(String value) {
  final symbol = _currencyFormat.currencySymbol;
  return '$value in  $symbol';
}
