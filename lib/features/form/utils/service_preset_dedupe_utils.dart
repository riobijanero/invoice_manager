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
