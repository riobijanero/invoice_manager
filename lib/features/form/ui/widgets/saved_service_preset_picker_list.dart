import 'package:flutter/material.dart';
import 'package:invoice_manager/common/models/saved_service_preset.dart';

/// One row in [SavedServicePresetPickerList].
class SavedServicePresetPickerEntry {
  const SavedServicePresetPickerEntry({
    required this.presetKey,
    required this.label,
    required this.preset,
  });

  final String presetKey;
  final String label;
  final SavedServicePreset preset;
}

/// Tap row to apply preset; X removes it from saved defaults.
class SavedServicePresetPickerList extends StatelessWidget {
  const SavedServicePresetPickerList({
    super.key,
    required this.entries,
    required this.onPresetSelected,
    required this.onPresetRemoveRequested,
    this.maxHeight = 280,
  });

  final List<SavedServicePresetPickerEntry> entries;
  final ValueChanged<SavedServicePreset> onPresetSelected;
  final ValueChanged<String> onPresetRemoveRequested;
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
              onTap: () => onPresetSelected(opt.preset),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        opt.label,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Tooltip(
                      message: 'Gespeicherte Leistung entfernen',
                      child: InkWell(
                        onTap: () => onPresetRemoveRequested(opt.presetKey),
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
