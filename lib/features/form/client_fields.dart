import 'package:flutter/material.dart';
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/features/form/ui/widgets/saved_client_picker_list.dart';

class ClientFields extends StatelessWidget {
  const ClientFields({
    super.key,
    required this.existingClients,
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
    final clientOptions = List<SavedClientPickerEntry>.generate(
      existingClients.length,
      (i) => SavedClientPickerEntry(
        clientKey: _clientKey(existingClients[i]),
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
        _CompanyFieldWithClientPicker(
          controller: clientCompanyNameController,
          clientNameController: clientNameController,
          clientOptions: clientOptions,
          onExistingClientPicked: onExistingClientPicked,
          onDeleteClientKey: onDeleteClientKey,
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
              return 'Firma oder Name erforderlich';
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

/// Opens the saved-client list in an overlay aligned under the company field (dropdown-style).
class _CompanyFieldWithClientPicker extends StatefulWidget {
  const _CompanyFieldWithClientPicker({
    required this.controller,
    required this.clientNameController,
    required this.clientOptions,
    required this.onExistingClientPicked,
    required this.onDeleteClientKey,
  });

  final TextEditingController controller;
  final TextEditingController clientNameController;
  final List<SavedClientPickerEntry> clientOptions;
  final ValueChanged<Client> onExistingClientPicked;
  final ValueChanged<String> onDeleteClientKey;

  @override
  State<_CompanyFieldWithClientPicker> createState() => _CompanyFieldWithClientPickerState();
}

class _CompanyFieldWithClientPickerState extends State<_CompanyFieldWithClientPicker> {
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  ScrollPosition? _scrollPositionLinked;

  @override
  void dispose() {
    _tearDownOverlay();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _CompanyFieldWithClientPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_overlayEntry != null &&
        (oldWidget.clientOptions.length != widget.clientOptions.length ||
            !_sameOptionKeys(oldWidget.clientOptions, widget.clientOptions))) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  bool _sameOptionKeys(List<SavedClientPickerEntry> a, List<SavedClientPickerEntry> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].clientKey != b[i].clientKey) return false;
    }
    return true;
  }

  void _tearDownOverlay() {
    _scrollPositionLinked?.removeListener(_onScrollOrLayoutChanged);
    _scrollPositionLinked = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onScrollOrLayoutChanged() {
    _overlayEntry?.markNeedsBuild();
  }

  void _toggleClientOverlay() {
    if (_overlayEntry != null) {
      _tearDownOverlay();
      return;
    }

    void insertWhenLaidOut() {
      final fieldContext = _fieldKey.currentContext;
      if (fieldContext == null || !fieldContext.mounted) return;

      final fieldBox = fieldContext.findRenderObject() as RenderBox?;
      if (fieldBox == null || !fieldBox.hasSize) return;

      final overlayState = Overlay.maybeOf(fieldContext);
      if (overlayState == null) return;

      _overlayEntry = OverlayEntry(
        builder: (overlayContext) {
          final overlayRender = Overlay.of(overlayContext).context.findRenderObject() as RenderBox?;

          final fc = _fieldKey.currentContext;
          if (fc == null || !fc.mounted || overlayRender == null) {
            return const SizedBox.shrink();
          }
          final fb = fc.findRenderObject() as RenderBox?;
          if (fb == null || !fb.hasSize) {
            return const SizedBox.shrink();
          }

          // Overlay-local coordinates — no CompositedTransformFollower / FollowerLayer.
          final bottomLeft = fb.localToGlobal(Offset(0, fb.size.height), ancestor: overlayRender);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _tearDownOverlay,
                ),
              ),
              Positioned(
                left: bottomLeft.dx,
                top: bottomLeft.dy + 2,
                width: fb.size.width,
                child: _buildMenuPanel(Theme.of(overlayContext)),
              ),
            ],
          );
        },
      );

      overlayState.insert(_overlayEntry!);

      final scrollable = Scrollable.maybeOf(fieldContext);
      _scrollPositionLinked = scrollable?.position;
      _scrollPositionLinked?.addListener(_onScrollOrLayoutChanged);
    }

    insertWhenLaidOut();
    if (_overlayEntry == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _overlayEntry != null) return;
        insertWhenLaidOut();
      });
    }
  }

  Widget _buildMenuPanel(ThemeData theme) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surface,
      child: widget.clientOptions.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Keine gespeicherten Kunden vorhanden.',
                style: theme.textTheme.bodyMedium,
              ),
            )
          : SavedClientPickerList(
              entries: widget.clientOptions,
              onClientSelected: (client) {
                _tearDownOverlay();
                widget.onExistingClientPicked(client);
              },
              onClientRemoveRequested: (clientKey) {
                widget.onDeleteClientKey(clientKey);
                _tearDownOverlay();
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldKey,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: 'Firma',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          tooltip: 'Aus vorhandenen Kunden wählen',
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: _toggleClientOverlay,
        ),
      ),
      validator: (v) {
        final company = v?.trim() ?? '';
        final name = widget.clientNameController.text.trim();
        if (company.isEmpty && name.isEmpty) {
          return 'Firma oder Name erforderlich';
        }
        return null;
      },
    );
  }
}
