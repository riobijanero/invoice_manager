import 'package:flutter/material.dart';
import 'package:invoice_manager/common/extensions/list_extensions.dart';

import 'package:invoice_manager/features/form/ui/widgets/expandable_form_section.dart';
import 'package:invoice_manager/features/form/widgets/field_row.dart';

class BankDetailsFields extends StatelessWidget {
  const BankDetailsFields({
    super.key,
    required this.accountHolderController,
    required this.institutionController,
    required this.ibanController,
    required this.bicController,
  });

  final TextEditingController accountHolderController;
  final TextEditingController institutionController;
  final TextEditingController ibanController;
  final TextEditingController bicController;

  static const double _minColumnWidth = 280;
  static const double _columnGap = 24;

  Widget _accountHolderField() {
    return TextFormField(
      controller: accountHolderController,
      decoration: const InputDecoration(
        labelText: 'Kontoinhaber',
        border: OutlineInputBorder(),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );
  }

  Widget _institutionField() {
    return TextFormField(
      controller: institutionController,
      decoration: const InputDecoration(
        labelText: 'Geldinstitut',
        border: OutlineInputBorder(),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );
  }

  Widget _ibanField() {
    return TextFormField(
      controller: ibanController,
      decoration: const InputDecoration(
        labelText: 'IBAN',
        border: OutlineInputBorder(),
      ),
      validator: (v) {
        final raw = v?.replaceAll(' ', '').trim().toUpperCase() ?? '';
        if (raw.isEmpty) return 'Pflichtfeld';
        if (!_isValidIban(raw)) return 'Ungültige IBAN';
        return null;
      },
    );
  }

  Widget _bicField() {
    return TextFormField(
      controller: bicController,
      decoration: const InputDecoration(
        labelText: 'BIC',
        border: OutlineInputBorder(),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );
  }

  bool _isValidIban(String iban) {
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

  @override
  Widget build(BuildContext context) {
    return ExpandableFormSection(
      title: 'Bankdaten (Absender)',
      expandTooltip: 'Bankdaten ausklappen',
      collapseTooltip: 'Bankdaten einklappen',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCols = constraints.maxWidth >= _minColumnWidth * 2 + _columnGap;
          if (twoCols) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FieldRow(left: _accountHolderField(), right: _institutionField()),
                const SizedBox(height: 12),
                FieldRow(left: _ibanField(), right: _bicField()),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _accountHolderField(),
              _institutionField(),
              _ibanField(),
              _bicField(),
            ].intersperse(const SizedBox(height: 12)),
          );
        },
      ),
    );
  }
}
