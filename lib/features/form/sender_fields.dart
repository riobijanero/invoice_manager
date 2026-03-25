import 'package:flutter/material.dart';
import 'package:invoice_manager/common/extensions/list_extensions.dart';

import 'package:invoice_manager/features/form/ui/widgets/expandable_form_section.dart';
import 'package:invoice_manager/features/form/widgets/field_row.dart';

class SenderFields extends StatelessWidget {
  const SenderFields({
    super.key,
    required this.senderNameController,
    required this.jobDescriptionController,
    required this.senderStreetNameAndNumberController,
    required this.senderPostalCodeController,
    required this.senderTownController,
    required this.senderCountryController,
    required this.senderPhoneController,
    required this.senderEmailController,
    required this.senderWebsiteController,
    required this.ustIdController,
    required this.taxNumberController,
  });

  final TextEditingController senderNameController;
  final TextEditingController jobDescriptionController;
  final TextEditingController senderStreetNameAndNumberController;
  final TextEditingController senderPostalCodeController;
  final TextEditingController senderTownController;
  final TextEditingController senderCountryController;
  final TextEditingController senderPhoneController;
  final TextEditingController senderEmailController;
  final TextEditingController senderWebsiteController;
  final TextEditingController ustIdController;
  final TextEditingController taxNumberController;

  static const double _minColumnWidth = 280;
  static const double _columnGap = 24;

  Widget _nameField() {
    return TextFormField(
      controller: senderNameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );
  }

  Widget _jobField() {
    return TextFormField(
      controller: jobDescriptionController,
      decoration: const InputDecoration(
        labelText: 'Jobbeschreibung (optional)',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _streetField() {
    return TextFormField(
      controller: senderStreetNameAndNumberController,
      decoration: const InputDecoration(
        labelText: 'Straße und Nr.',
        border: OutlineInputBorder(),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );
  }

  Widget _plzField() {
    return TextFormField(
      controller: senderPostalCodeController,
      decoration: const InputDecoration(
        labelText: 'PLZ',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Pflichtfeld';
        final n = int.tryParse(v.trim());
        if (n == null || n <= 0) return 'Ungültige PLZ';
        return null;
      },
    );
  }

  Widget _townField() {
    return TextFormField(
      controller: senderTownController,
      decoration: const InputDecoration(
        labelText: 'Ort',
        border: OutlineInputBorder(),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );
  }

  Widget _countryField() {
    return TextFormField(
      controller: senderCountryController,
      decoration: const InputDecoration(
        labelText: 'Land',
        border: OutlineInputBorder(),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );
  }

  Widget _phoneField() {
    return TextFormField(
      controller: senderPhoneController,
      decoration: const InputDecoration(
        labelText: 'Telefon',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: senderEmailController,
      decoration: const InputDecoration(
        labelText: 'E-Mail',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _websiteField() {
    return TextFormField(
      controller: senderWebsiteController,
      decoration: const InputDecoration(
        labelText: 'Website',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _ustField() {
    return TextFormField(
      controller: ustIdController,
      decoration: const InputDecoration(
        labelText: 'USt-ID (z.B: DE123456789)',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _taxField() {
    return TextFormField(
      controller: taxNumberController,
      decoration: const InputDecoration(
        labelText: 'Steuernummer (z.B: 012/345/67890)',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _fieldsBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final twoCols = maxW >= _minColumnWidth * 2 + _columnGap;

        if (twoCols) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FieldRow(left: _nameField(), right: _jobField()),
              FieldRow(left: _streetField(), right: _plzField()),
              FieldRow(left: _townField(), right: _countryField()),
              FieldRow(left: _phoneField(), right: _emailField()),
              FieldRow(left: _websiteField(), right: _ustField()),
              FieldRow(left: _taxField(), right: const SizedBox.shrink()),
            ].intersperse(const SizedBox(height: 12)),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _nameField(),
            _jobField(),
            _streetField(),
            _plzField(),
            _townField(),
            _countryField(),
            _phoneField(),
            _emailField(),
            _websiteField(),
            _ustField(),
            _taxField(),
          ].intersperse(const SizedBox(height: 12)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFormSection(
      title: 'Absender',
      expandTooltip: 'Absender ausklappen',
      collapseTooltip: 'Absender einklappen',
      child: _fieldsBody(),
    );
  }
}
