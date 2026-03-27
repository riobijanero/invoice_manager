import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Live query string for filtering the invoice list (empty → no filtering).
final invoiceListSearchQueryProvider = StateProvider<String>((ref) => '');
