import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_manager/features/form/utils/utils.dart';

void main() {
  test('isValidIban accepts spaced valid DE IBAN', () {
    // Commonly used valid example IBAN (Germany).
    expect(isValidIban('DE89 3704 0044 0532 0130 00'), true);
    expect(isValidIban('de89 3704 0044 0532 0130 00'), true);
    expect(isValidIban('DE89370400440532013000'), true);
    // Also accept non-breaking spaces from copy/paste.
    expect(isValidIban('DE89\u00A03704\u00A00044\u00A00532\u00A00130\u00A000'), true);
    // Also accept zero-width characters that show up from PDFs.
    expect(isValidIban('DE89\u200B3704\u200B0044\u200B0532\u200B0130\u200B00'), true);
  });
}

