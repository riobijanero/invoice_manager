import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_defaults.dart';
import '../models/invoice.dart';
import '../repositories/defaults_repository.dart';
import '../repositories/invoice_repository.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository();
});

final defaultsRepositoryProvider = Provider<DefaultsRepository>((ref) {
  return DefaultsRepository();
});

final invoiceListProvider = FutureProvider<List<Invoice>>((ref) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  return repo.getAll();
});

final defaultsProvider = FutureProvider<AppDefaults>((ref) async {
  final repo = ref.watch(defaultsRepositoryProvider);
  return repo.load();
});

final invoiceDetailProvider =
    FutureProvider.family<Invoice?, String>((ref, id) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  return repo.getById(id);
});
