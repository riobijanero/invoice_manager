import 'package:flutter/material.dart';
import 'package:invoice_manager/common/models/client.dart';

class ClientFields extends StatelessWidget {
  const ClientFields({
    super.key,
    required this.existingClients,
    required this.selectedClientKey,
    required this.onSelectedClientKeyChanged,
    required this.onExistingClientPicked,
    required this.onDeleteClientKey,
    required this.clientCompanyNameController,
    required this.clientNameController,
    required this.clientStreetNameAndNumberController,
    required this.clientPostalCodeController,
    required this.clientTownController,
    required this.clientCountryController,
    required this.contractNumberController,
  });

  final List<Client> existingClients;
  final String? selectedClientKey;
  final ValueChanged<String?> onSelectedClientKeyChanged;
  final ValueChanged<Client> onExistingClientPicked;
  final ValueChanged<String> onDeleteClientKey;
  final TextEditingController clientCompanyNameController;
  final TextEditingController clientNameController;
  final TextEditingController clientStreetNameAndNumberController;
  final TextEditingController clientPostalCodeController;
  final TextEditingController clientTownController;
  final TextEditingController clientCountryController;
  final TextEditingController contractNumberController;

  @override
  Widget build(BuildContext context) {
    final clientOptions = List<_ClientOption>.generate(
      existingClients.length,
      (i) => _ClientOption(
        key: _clientKey(existingClients[i]),
        client: existingClients[i],
        label: _clientLabel(existingClients[i]),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kunde',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedClientKey,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'aus vorhandenen Kunden wählen',
            border: OutlineInputBorder(),
          ),
          selectedItemBuilder: (context) {
            return [
              const Text('Manuell eingeben', overflow: TextOverflow.ellipsis),
              ...clientOptions.map((opt) => Text(opt.label, overflow: TextOverflow.ellipsis)),
            ];
          },
          items: [
            const DropdownMenuItem<String>(
              value: '',
              child: Text('Manuell eingeben'),
            ),
            ...clientOptions.map(
              (opt) => DropdownMenuItem<String>(
                value: opt.key,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                  title: Text(
                    opt.label,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    tooltip: 'Kunde entfernen',
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      onDeleteClientKey(opt.key);
                      if (selectedClientKey == opt.key) {
                        onSelectedClientKeyChanged(null);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
          onChanged: (selected) {
            final normalized = (selected == null || selected.isEmpty) ? null : selected;
            onSelectedClientKeyChanged(normalized);
            if (normalized == null) return;
            Client? picked;
            for (final opt in clientOptions) {
              if (opt.key == normalized) {
                picked = opt.client;
                break;
              }
            }
            if (picked != null) {
              onExistingClientPicked(picked);
            }
          },
        ),
        const SizedBox(height: 12),
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

String _clientLabel(Client client) {
  final company = client.companyName.trim();
  if (company.isNotEmpty) return company;
  final name = client.name.trim();
  if (name.isNotEmpty) return name;
  return 'Unbenannter Kunde';
}

String _clientKey(Client client) {
  return [
    client.companyName.trim().toLowerCase(),
    client.name.trim().toLowerCase(),
    client.address.streetNameAndNumber.trim().toLowerCase(),
    client.address.postalCode.toString(),
    client.address.town.trim().toLowerCase(),
    client.address.country.trim().toLowerCase(),
  ].join('|');
}

class _ClientOption {
  const _ClientOption({
    required this.key,
    required this.client,
    required this.label,
  });

  final String key;
  final Client client;
  final String label;
}
