// Form utilities used across invoice-related widgets.
//
// Returns the next invoice number based on the previously stored one.
//
// Supports either plain integers (e.g. `"12"`) or prefixed numbers with
// numeric suffix (e.g. `"INV-00012"` -> `"INV-00013"`).
String nextInvoiceNumber(String lastInvoiceNumber) {
  final raw = lastInvoiceNumber.trim();
  if (raw.isEmpty) return '1';

  final m = RegExp(r'^(.*?)(\d+)$').firstMatch(raw);
  if (m == null) {
    final asInt = int.tryParse(raw);
    return '${(asInt ?? 0) + 1}';
  }

  final prefix = m.group(1) ?? '';
  final digits = m.group(2)!;
  final width = digits.length;
  final value = int.parse(digits);
  final next = (value + 1).toString().padLeft(width, '0');
  return '$prefix$next';
}

bool isValidIban(String iban) {
  // IBAN: 2-letter country code, 2 check digits, and 11..30 BBAN chars (overall 15..34).
  if (iban.length < 15 || iban.length > 34) return false;
  if (!RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]+$').hasMatch(iban)) return false;

  // Rearrange: move first 4 chars to the end.
  final rearranged = '${iban.substring(4)}${iban.substring(0, 4)}';

  // Compute mod-97 for the numeric string without big integers.
  var remainder = 0;
  for (final ch in rearranged.split('')) {
    if (RegExp(r'^\d$').hasMatch(ch)) {
      remainder = (remainder * 10 + int.parse(ch)) % 97;
    } else {
      final value = ch.codeUnitAt(0) - 'A'.codeUnitAt(0) + 10; // 10..35
      final digits = value.toString().split('');
      for (final d in digits) {
        remainder = (remainder * 10 + int.parse(d)) % 97;
      }
    }
  }

  // Valid IBANs have remainder 1.
  return remainder == 1;
}
