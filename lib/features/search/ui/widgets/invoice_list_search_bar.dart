import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/saved_service_preset.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:invoice_manager/features/form/ui/widgets/clearable_input_decoration.dart';
import 'package:invoice_manager/features/form/utils/client_dedupe_utils.dart';
import 'package:invoice_manager/features/form/utils/service_preset_dedupe_utils.dart';
import 'package:invoice_manager/features/search/providers/invoice_list_filter_providers.dart';
import 'package:invoice_manager/features/search/providers/invoice_list_search_query_provider.dart';

/// Suchfeld und optionale Filter (Kunde, Leistung) für die Rechnungsliste.
class InvoiceListSearchBar extends ConsumerStatefulWidget {
  const InvoiceListSearchBar({super.key});

  @override
  ConsumerState<InvoiceListSearchBar> createState() => _InvoiceListSearchBarState();
}

class _InvoiceListSearchBarState extends ConsumerState<InvoiceListSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(invoiceListSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clampFilterKeysIfNeeded(
    List<Client> clients,
    List<SavedServicePreset> presets,
    String? clientKey,
    String? serviceKey,
  ) {
    final clientOk =
        clientKey == null || clients.any((c) => clientDedupeKey(c) == clientKey);
    final presetKeys = {for (final p in presets) servicePresetDedupeKey(p)};
    final serviceOk = serviceKey == null || presetKeys.contains(serviceKey);
    if (!clientOk) {
      Future.microtask(() {
        if (ref.read(invoiceListFilterClientKeyProvider) == clientKey) {
          ref.read(invoiceListFilterClientKeyProvider.notifier).state = null;
        }
      });
    }
    if (!serviceOk) {
      Future.microtask(() {
        if (ref.read(invoiceListFilterServicePresetKeyProvider) == serviceKey) {
          ref.read(invoiceListFilterServicePresetKeyProvider.notifier).state = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(invoiceListSearchQueryProvider);
    final panelOpen = ref.watch(invoiceListFilterPanelExpandedProvider);
    final clientKey = ref.watch(invoiceListFilterClientKeyProvider);
    final serviceKey = ref.watch(invoiceListFilterServicePresetKeyProvider);
    final invoicesAsync = ref.watch(invoiceListProvider);
    final defaultsAsync = ref.watch(defaultsProvider);

    final theme = Theme.of(context);
    final hasActiveFilters =
        (clientKey != null && clientKey.isNotEmpty) ||
            (serviceKey != null && serviceKey.isNotEmpty);
    final highlightFilter =
        panelOpen || hasActiveFilters;

    final invoices = invoicesAsync.valueOrNull ?? [];
    final defaults = defaultsAsync.valueOrNull;
    final clients = mergedClientsForInvoiceListFilter(
      invoices,
      defaults?.client ?? const Client(),
    );
    final presets = defaults?.savedServicePresets ?? const [];

    _clampFilterKeysIfNeeded(clients, presets, clientKey, serviceKey);

    final dropdownClientValue =
        clientKey != null && clients.any((c) => clientDedupeKey(c) == clientKey)
            ? clientKey
            : null;
    final presetKeys = {for (final p in presets) servicePresetDedupeKey(p)};
    final dropdownServiceValue =
        serviceKey != null && presetKeys.contains(serviceKey) ? serviceKey : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            decoration: inputDecorationWithClear(
              controller: _controller,
              clearTooltip: 'Suche löschen',
              onAfterClear: () {
                ref.read(invoiceListSearchQueryProvider.notifier).state = '';
              },
              decoration: InputDecoration(
                hintText: 'Alle Rechnungsdaten durchsuchen …',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: Tooltip(
                  message: panelOpen
                      ? 'Filter ausblenden'
                      : 'Nach Kunde und Leistung filtern',
                  child: IconButton(
                    onPressed: () {
                      ref.read(invoiceListFilterPanelExpandedProvider.notifier).state =
                          !panelOpen;
                    },
                    icon: const Icon(Icons.filter_list),
                    style: IconButton.styleFrom(
                      foregroundColor:
                          highlightFilter ? theme.colorScheme.primary : null,
                      backgroundColor: highlightFilter
                          ? theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.35)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            onChanged: (v) {
              ref.read(invoiceListSearchQueryProvider.notifier).state = v;
            },
          ),
          if (panelOpen) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Kunde',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              value: dropdownClientValue,
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Alle Kunden'),
                ),
                ...clients.map(
                  (c) => DropdownMenuItem<String?>(
                    value: clientDedupeKey(c),
                    child: Text(
                      clientMenuLabel(c),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: (v) {
                ref.read(invoiceListFilterClientKeyProvider.notifier).state = v;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Leistung / Produkt',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              value: dropdownServiceValue,
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Alle Leistungen'),
                ),
                ...presets.map(
                  (p) => DropdownMenuItem<String?>(
                    value: servicePresetDedupeKey(p),
                    child: Text(
                      servicePresetMenuLabel(p),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
              onChanged: (v) {
                ref.read(invoiceListFilterServicePresetKeyProvider.notifier).state = v;
              },
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
