import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Absender',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final twoCols = maxW >= _minColumnWidth * 2 + _columnGap;

            if (twoCols) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _fieldRow(_nameField(), _jobField()),
                  const SizedBox(height: 12),
                  _fieldRow(_streetField(), _plzField()),
                  const SizedBox(height: 12),
                  _fieldRow(_townField(), _countryField()),
                  const SizedBox(height: 12),
                  _fieldRow(_phoneField(), _emailField()),
                  const SizedBox(height: 12),
                  _fieldRow(_websiteField(), _ustField()),
                  const SizedBox(height: 12),
                  _fieldRow(_taxField(), const SizedBox.shrink()),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _nameField(),
                const SizedBox(height: 8),
                _jobField(),
                const SizedBox(height: 12),
                _streetField(),
                const SizedBox(height: 12),
                _plzField(),
                const SizedBox(height: 12),
                _townField(),
                const SizedBox(height: 12),
                _countryField(),
                const SizedBox(height: 12),
                _phoneField(),
                const SizedBox(height: 12),
                _emailField(),
                const SizedBox(height: 12),
                _websiteField(),
                const SizedBox(height: 12),
                _ustField(),
                const SizedBox(height: 12),
                _taxField(),
              ],
            );
          },
        ),
      ],
    );
  }
}
