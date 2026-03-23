import 'package:flutter/material.dart';
import 'package:invoice_manager/common/models/client.dart';

/// One row in [SavedClientPickerList] (dedupe key + display label + full client).
class SavedClientPickerEntry {
  const SavedClientPickerEntry({
    required this.clientKey,
    required this.label,
    required this.client,
  });

  final String clientKey;
  final String label;
  final Client client;
}

/// Scrollable list of saved clients: tap row to pick, X to remove from picker memory.
class SavedClientPickerList extends StatelessWidget {
  const SavedClientPickerList({
    super.key,
    required this.entries,
    required this.onClientSelected,
    required this.onClientRemoveRequested,
    this.maxHeight = 280,
  });

  final List<SavedClientPickerEntry> entries;
  final ValueChanged<Client> onClientSelected;
  final ValueChanged<String> onClientRemoveRequested;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: entries.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: theme.dividerColor,
        ),
        itemBuilder: (_, index) {
          final opt = entries[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onClientSelected(opt.client),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        opt.label,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Tooltip(
                      message: 'Kunde entfernen',
                      child: InkWell(
                        onTap: () => onClientRemoveRequested(opt.clientKey),
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(8, 4, 10, 4),
                          child: Icon(Icons.close, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
