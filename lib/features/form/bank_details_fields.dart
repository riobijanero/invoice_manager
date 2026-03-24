import 'package:flutter/material.dart';

import 'package:invoice_manager/features/form/ui/widgets/expandable_form_section.dart';

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
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
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

  Widget _fieldRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: _columnGap),
        Expanded(child: right),
      ],
    );
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
                _fieldRow(_accountHolderField(), _institutionField()),
                const SizedBox(height: 12),
                _fieldRow(_ibanField(), _bicField()),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _accountHolderField(),
              const SizedBox(height: 12),
              _institutionField(),
              const SizedBox(height: 12),
              _ibanField(),
              const SizedBox(height: 12),
              _bicField(),
            ],
          );
        },
      ),
    );
  }
}
