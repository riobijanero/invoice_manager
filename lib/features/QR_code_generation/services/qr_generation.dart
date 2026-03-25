import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';

class QrGenerationService {
  String generateGiroCodeString(Invoice invoice) {
    // 1) Subtotal (net) from all invoice items.
    final subtotalCents = invoice.invoiceItemList.fold<int>(
      0,
      (sum, item) => sum + _toCents(item.itemTotal),
    );

    // 2) Apply discount (percent or absolute).
    int discountedCents = subtotalCents;
    if (invoice.discountType == DiscountType.percent) {
      final discountCents = ((subtotalCents * invoice.discountValue) / 100).round();
      discountedCents -= discountCents;
    } else {
      discountedCents -= _toCents(invoice.discountValue);
    }
    if (discountedCents < 0) discountedCents = 0;

    // 3) Apply VAT.
    final vatRate = invoice.vat;
    final vatCents = (discountedCents * vatRate).round();
    final totalCents = discountedCents + vatCents;

    // 4) Format EPC/GiroCode (EPC069-12 / BCD) string.
    // EPC069-12 requires amount >= 0.01. Some scanners treat 0 as invalid.
    final safeTotalCents = totalCents <= 0 ? 1 : totalCents;

    final bic = _sanitizeValue(invoice.bankDetails.bic, maxLen: 11);
    final iban = _sanitizeValue(invoice.bankDetails.iban, maxLen: 34);
    final beneficiaryName = _sanitizeSingleLine(
      invoice.sender.name.trim().isNotEmpty ? invoice.sender.name : invoice.bankDetails.accountHolder,
      maxLen: 70,
    );

    final lines = <String>[
      'BCD', // Service Tag
      '001', // Version (paired with character set 1 / UTF-8)
      '1', // Character set: UTF-8
      'SCT', // SEPA Credit Transfer
      bic, // BIC (may be empty depending on country)
      beneficiaryName, // Beneficiary name
      iban, // IBAN (no spaces)
      'EUR${_formatCents(safeTotalCents)}', // Amount (>= 0.01)
      'GDDS', // Purpose Code (recommended default for compatibility)
      '', // Structured Reference (empty)
      invoice.invoiceNumber.trim(), // Remittance Information
      '', // User Information (empty)
    ];

    // EPC069-12: "The last populated element is not followed by any character
    // or element separator". Many banking apps reject trailing empty lines.
    while (lines.isNotEmpty && lines.last.isEmpty) {
      lines.removeLast();
    }

    return lines.join('\r\n');
  }

  int _toCents(double value) {
    // Avoid floating point drift by rounding to cents at every step.
    return (value * 100).round();
  }

  String _formatCents(int cents) {
    final sign = cents < 0 ? '-' : '';
    final abs = cents.abs();
    final euros = abs ~/ 100;
    final rem = abs % 100;
    return '$sign$euros.${rem.toString().padLeft(2, '0')}';
  }

  String _sanitizeValue(String value, {required int maxLen}) {
    final v = value.replaceAll(' ', '').trim().toUpperCase();
    return v.length > maxLen ? v.substring(0, maxLen) : v;
  }

  String _sanitizeSingleLine(
    String value, {
    int maxLen = 70,
  }) {
    final v = value.replaceAll('\r', ' ').replaceAll('\n', ' ').trim();
    if (v.isEmpty) return v;
    return v.length > maxLen ? v.substring(0, maxLen) : v;
  }
}

