import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/app_defaults.dart';

const String _defaultsFileName = 'invoice_defaults.json';

/// Persists and loads last-used defaults for new invoices.
class DefaultsRepository {
  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return path.join(dir.path, 'invoice_manager', _defaultsFileName);
  }

  Future<AppDefaults> load() async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    if (!await file.exists()) {
      return const AppDefaults(
        serviceDescriptionTemplate: defaultServiceDescriptionTemplate,
      );
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return const AppDefaults(
        serviceDescriptionTemplate: defaultServiceDescriptionTemplate,
      );
    }
    return AppDefaults.fromJson(
      jsonDecode(content) as Map<String, dynamic>,
    );
  }

  Future<void> save(AppDefaults defaults) async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    final dir = file.parent;
    if (!await dir.exists()) await dir.create(recursive: true);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(defaults.toJson()),
    );
  }
}
