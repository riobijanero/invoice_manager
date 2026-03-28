import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/models/saved_service_preset.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';

/// Stable key for deduplicating presets (trimmed text + price + unit).
String servicePresetDedupeKey(SavedServicePreset p) {
  final d = p.description.trim();
  final rounded = (p.unitPrice * 10000).round() / 10000;
  return '$d\n$rounded\n${p.unitType.name}';
}

/// Gleiche Schlüssellogik wie [SavedServicePreset] für eine Rechnungsposition.
String invoiceLineServicePresetKey(InvoiceItem item) {
  return servicePresetDedupeKey(SavedServicePreset(
    description: item.serviceDescription,
    unitPrice: item.unitPrice,
    unitType: item.unitType,
  ));
}

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

/// Kurztext für Dropdowns (Filter, Formular).
String servicePresetMenuLabel(SavedServicePreset p) {
  final firstLine = p.description.trim().split(RegExp(r'\r?\n')).first;
  final short =
      firstLine.length > 72 ? '${firstLine.substring(0, 69)}…' : firstLine;
  final u = _unitTypeAbbrev(p.unitType);
  if (short.isEmpty) return '${formatCurrency(p.unitPrice)} · $u';
  return '$short · ${formatCurrency(p.unitPrice)} · $u';
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
