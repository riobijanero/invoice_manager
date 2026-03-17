import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/invoice.dart';

const String _invoicesFileName = 'invoices.json';

/// File-based local storage for invoices. CRUD and list sorted by date (newest first).
class InvoiceRepository {
  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return path.join(dir.path, 'invoice_manager', _invoicesFileName);
  }

  Future<List<Invoice>> getAll() async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];
    final list = jsonDecode(content) as List<dynamic>;
    final invoices = list
        .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
        .toList();
    invoices.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return invoices;
  }

  Future<Invoice?> getById(String id) async {
    final all = await getAll();
    try {
      return all.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(Invoice invoice) async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    final all = await getAll();
    final index = all.indexWhere((i) => i.id == invoice.id);
    final updated = invoice.copyWith(updatedAt: DateTime.now());
    if (index >= 0) {
      all[index] = updated;
    } else {
      all.insert(0, updated);
    }
    final dir = file.parent;
    if (!await dir.exists()) await dir.create(recursive: true);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(all.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> delete(String id) async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    if (!await file.exists()) return;
    final all = await getAll();
    final filtered = all.where((i) => i.id != id).toList();
    if (filtered.isEmpty) {
      await file.writeAsString('[]');
    } else {
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(filtered.map((e) => e.toJson()).toList()),
      );
    }
  }
}
