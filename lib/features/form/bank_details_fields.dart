import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bankdaten (Absender)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: accountHolderController,
          decoration: const InputDecoration(
            labelText: 'Kontoinhaber',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: institutionController,
          decoration: const InputDecoration(
            labelText: 'Geldinstitut',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: ibanController,
          decoration: const InputDecoration(
            labelText: 'IBAN',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: bicController,
          decoration: const InputDecoration(
            labelText: 'BIC',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
      ],
    );
  }
}
