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
        TextFormField(
          controller: senderNameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: jobDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Jobbeschreibung (optional)',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: senderStreetNameAndNumberController,
          decoration: const InputDecoration(
            labelText: 'Straße und Nr.',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
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
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: senderTownController,
          decoration: const InputDecoration(
            labelText: 'Ort',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: senderCountryController,
          decoration: const InputDecoration(
            labelText: 'Land',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: senderPhoneController,
          decoration: const InputDecoration(
            labelText: 'Telefon',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: senderEmailController,
          decoration: const InputDecoration(
            labelText: 'E-Mail',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: senderWebsiteController,
          decoration: const InputDecoration(
            labelText: 'Website',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: ustIdController,
          decoration: const InputDecoration(
            labelText: 'USt-ID (z.B: DE123456789)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: taxNumberController,
          decoration: const InputDecoration(
            labelText: 'Steuernummer (z.B: 012/345/67890)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
