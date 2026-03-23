import 'package:flutter/material.dart';

class ClientFields extends StatelessWidget {
  const ClientFields({
    super.key,
    required this.clientCompanyNameController,
    required this.clientNameController,
    required this.clientStreetNameAndNumberController,
    required this.clientPostalCodeController,
    required this.clientTownController,
    required this.clientCountryController,
    required this.contractNumberController,
  });

  final TextEditingController clientCompanyNameController;
  final TextEditingController clientNameController;
  final TextEditingController clientStreetNameAndNumberController;
  final TextEditingController clientPostalCodeController;
  final TextEditingController clientTownController;
  final TextEditingController clientCountryController;
  final TextEditingController contractNumberController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kunde',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: clientCompanyNameController,
          decoration: const InputDecoration(
            labelText: 'Firma (optional)',
            border: OutlineInputBorder(),
          ),
          validator: (v) {
            final company = v?.trim() ?? '';
            final name = clientNameController.text.trim();
            if (company.isEmpty && name.isEmpty) {
              return 'Name oder Firma erforderlich';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: clientNameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          validator: (v) {
            final name = v?.trim() ?? '';
            final company = clientCompanyNameController.text.trim();
            if (name.isEmpty && company.isEmpty) {
              return 'Name oder Firma erforderlich';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: clientStreetNameAndNumberController,
          decoration: const InputDecoration(
            labelText: 'Straße und Nr.',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: clientPostalCodeController,
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
          controller: clientTownController,
          decoration: const InputDecoration(
            labelText: 'Ort',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: clientCountryController,
          decoration: const InputDecoration(
            labelText: 'Land',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: contractNumberController,
          decoration: const InputDecoration(
            labelText: 'Vertragsnummer (optional)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
