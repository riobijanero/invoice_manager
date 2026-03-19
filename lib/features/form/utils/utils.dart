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
