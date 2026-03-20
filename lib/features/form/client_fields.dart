import 'package:flutter/material.dart';

class ClientFields extends StatelessWidget {
  const ClientFields({
    super.key,
    required this.clientCompanyNameController,
    required this.clientNameController,
    required this.clientAddressController,
    required this.contractNumberController,
  });

  final TextEditingController clientCompanyNameController;
  final TextEditingController clientNameController;
  final TextEditingController clientAddressController;
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
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: clientNameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: clientAddressController,
          decoration: const InputDecoration(
            labelText: 'Adresse',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
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
