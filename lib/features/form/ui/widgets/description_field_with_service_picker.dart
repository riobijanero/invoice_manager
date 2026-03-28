import 'package:flutter/material.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/models/saved_service_preset.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
import 'package:invoice_manager/features/form/ui/widgets/saved_service_preset_picker_list.dart';
import 'package:invoice_manager/features/form/utils/service_preset_dedupe_utils.dart';

String _unitTypeAbbrev(UnitType t) {
  switch (t) {
    case UnitType.hours:
      return 'Std.';
    case UnitType.minutes:
      return 'Min.';
    case UnitType.amount:
      return 'Stk.';
  }
}

String servicePresetPickerLabel(SavedServicePreset p) {
  final firstLine = p.description.trim().split(RegExp(r'\r?\n')).first;
  final short =
      firstLine.length > 72 ? '${firstLine.substring(0, 69)}…' : firstLine;
  final u = _unitTypeAbbrev(p.unitType);
  if (short.isEmpty) return '${formatCurrency(p.unitPrice)} · $u';
  return '$short · ${formatCurrency(p.unitPrice)} · $u';
}

/// [Leistungsbeschreibung] with a dropdown-style control to pick saved presets.
class DescriptionFieldWithServicePicker extends StatefulWidget {
  const DescriptionFieldWithServicePicker({
    super.key,
    required this.controller,
    required this.presetEntries,
    required this.onPresetSelected,
    required this.onPresetRemoveRequested,
  });

  final TextEditingController controller;
  final List<SavedServicePresetPickerEntry> presetEntries;
  final ValueChanged<SavedServicePreset> onPresetSelected;
  final ValueChanged<String> onPresetRemoveRequested;

  @override
  State<DescriptionFieldWithServicePicker> createState() =>
      _DescriptionFieldWithServicePickerState();
}

class _DescriptionFieldWithServicePickerState
    extends State<DescriptionFieldWithServicePicker> {
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  ScrollPosition? _scrollPositionLinked;

  @override
  void dispose() {
    _tearDownOverlay();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DescriptionFieldWithServicePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_overlayEntry != null &&
        (oldWidget.presetEntries.length != widget.presetEntries.length ||
            !_sameOptionKeys(oldWidget.presetEntries, widget.presetEntries))) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  bool _sameOptionKeys(
    List<SavedServicePresetPickerEntry> a,
    List<SavedServicePresetPickerEntry> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].presetKey != b[i].presetKey) return false;
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

  void _toggleOverlay() {
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
          final overlayRender =
              Overlay.of(overlayContext).context.findRenderObject() as RenderBox?;

          final fc = _fieldKey.currentContext;
          if (fc == null || !fc.mounted || overlayRender == null) {
            return const SizedBox.shrink();
          }
          final fb = fc.findRenderObject() as RenderBox?;
          if (fb == null || !fb.hasSize) {
            return const SizedBox.shrink();
          }

          final bottomLeft =
              fb.localToGlobal(Offset(0, fb.size.height), ancestor: overlayRender);

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
      child: widget.presetEntries.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Keine gespeicherten Leistungen. Unter der Beschreibung auf '
                '„Vorlage speichern“ tippen (Beschreibung und Einzelpreis '
                'ausfüllen).',
                style: theme.textTheme.bodyMedium,
              ),
            )
          : SavedServicePresetPickerList(
              entries: widget.presetEntries,
              onPresetSelected: (preset) {
                _tearDownOverlay();
                widget.onPresetSelected(preset);
              },
              onPresetRemoveRequested: (key) {
                widget.onPresetRemoveRequested(key);
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
        labelText: 'Leistungsbeschreibung',
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
        suffixIcon: IconButton(
          tooltip: 'Gespeicherte Leistung wählen',
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: _toggleOverlay,
        ),
      ),
      maxLines: 5,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );
  }
}

/// Builds picker entries from defaults (dedupe key + label).
List<SavedServicePresetPickerEntry> savedServicePresetPickerEntries(
  List<SavedServicePreset> presets,
) {
  return presets
      .map(
        (p) => SavedServicePresetPickerEntry(
          presetKey: servicePresetDedupeKey(p),
          label: servicePresetPickerLabel(p),
          preset: p,
        ),
      )
      .toList();
}
