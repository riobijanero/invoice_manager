import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Filter-Panel unter der Suche ein-/ausblenden.
final invoiceListFilterPanelExpandedProvider = StateProvider<bool>((ref) => false);

/// `null` = alle Kunden; sonst [clientDedupeKey].
final invoiceListFilterClientKeyProvider = StateProvider<String?>((ref) => null);

/// `null` = alle Leistungen; sonst [servicePresetDedupeKey].
final invoiceListFilterServicePresetKeyProvider = StateProvider<String?>((ref) => null);
