import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_defaults.dart';
import 'package:invoice_manager/repositories/defaults_repository.dart';
import 'package:invoice_manager/repositories/invoice_repository.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository();
});

final defaultsRepositoryProvider = Provider<DefaultsRepository>((ref) {
  return DefaultsRepository();
});

final invoiceListProvider = FutureProvider<List<Invoice>>((ref) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  final list = await repo.getAll();
  // [getAll] already sorts; keep explicit so UI order never drifts.
  sortInvoicesByCreatedAtNewestFirst(list);
  return list;
});

final defaultsProvider = FutureProvider<InvoiceDefaults>((ref) async {
  final repo = ref.watch(defaultsRepositoryProvider);
  return repo.load();
});

final invoiceDetailProvider = FutureProvider.family<Invoice?, String>((ref, id) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  return repo.getById(id);
});
