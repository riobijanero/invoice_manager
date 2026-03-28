import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/models/saved_service_preset.dart';

/// Stable key for deduplicating presets (trimmed text + price + unit).
String servicePresetDedupeKey(SavedServicePreset p) {
  final d = p.description.trim();
  final rounded = (p.unitPrice * 10000).round() / 10000;
  return '$d\n$rounded\n${p.unitType.name}';
}

/// Newest-first: [fromInvoiceLines] first, then [existing] without duplicates.
List<SavedServicePreset> mergeSavedServicePresets(
  List<SavedServicePreset> existing,
  List<SavedServicePreset> fromInvoiceLines,
) {
  final seen = <String>{};
  final out = <SavedServicePreset>[];

  void add(SavedServicePreset p) {
    final k = servicePresetDedupeKey(p);
    if (seen.contains(k)) return;
    seen.add(k);
    out.add(p);
  }

  for (final p in fromInvoiceLines) {
    if (p.description.trim().isEmpty) continue;
    add(p);
  }
  for (final p in existing) {
    add(p);
  }
  return out;
}

/// Builds presets from current form rows (non-empty trimmed description).
List<SavedServicePreset> savedServicePresetsFromFormRows({
  required List<String> descriptions,
  required List<String> unitPriceTexts,
  required List<UnitType> unitTypes,
}) {
  var n = descriptions.length;
  if (unitPriceTexts.length < n) n = unitPriceTexts.length;
  if (unitTypes.length < n) n = unitTypes.length;
  final out = <SavedServicePreset>[];
  for (var i = 0; i < n; i++) {
    final d = descriptions[i].trim();
    if (d.isEmpty) continue;
    final price =
        double.tryParse(unitPriceTexts[i].replaceFirst(',', '.')) ?? 0.0;
    out.add(SavedServicePreset(
      description: d,
      unitPrice: price,
      unitType: unitTypes[i],
    ));
  }
  return out;
}
