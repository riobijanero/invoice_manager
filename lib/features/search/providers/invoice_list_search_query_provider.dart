import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Aktueller Suchtext auf der Rechnungsliste; leer = keine Filterung.
final invoiceListSearchQueryProvider = StateProvider<String>((ref) => '');
