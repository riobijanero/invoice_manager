import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:invoice_manager/common/models/invoice_defaults.dart';

const String _defaultsFileName = 'invoice_defaults.json';

/// Persists and loads last-used defaults for new invoices.
class DefaultsRepository {
  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return path.join(dir.path, 'invoice_manager', _defaultsFileName);
  }

  Future<InvoiceDefaults> load() async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    if (!await file.exists()) {
      return const InvoiceDefaults(
        serviceDescriptionTemplate: defaultServiceDescriptionTemplate,
      );
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return const InvoiceDefaults(
        serviceDescriptionTemplate: defaultServiceDescriptionTemplate,
      );
    }
    final raw = jsonDecode(content) as Map<String, dynamic>;
    final normalized = _normalizeDefaultsJson(raw);
    return InvoiceDefaults.fromJson(normalized);
  }

  Future<void> save(InvoiceDefaults defaults) async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    final dir = file.parent;
    if (!await dir.exists()) await dir.create(recursive: true);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(defaults.toJson()),
    );
  }
}

Map<String, dynamic> _normalizeDefaultsJson(Map<String, dynamic> raw) {
  final normalized = Map<String, dynamic>.from(raw);
  normalized['sender'] = _normalizePartyJson(raw['sender']);
  normalized['client'] = _normalizePartyJson(raw['client']);
  return normalized;
}

Map<String, dynamic> _normalizePartyJson(Object? value) {
  if (value is! Map<String, dynamic>) return <String, dynamic>{};
  final party = Map<String, dynamic>.from(value);
  party['address'] = _normalizeAddressJson(party['address']);
  return party;
}

Map<String, dynamic> _normalizeAddressJson(Object? value) {
  // Legacy format: plain string address.
  if (value is String) {
    return <String, dynamic>{
      'streetNameAndNumber': value,
      'postalCode': 0,
      'town': '',
      'country': '',
    };
  }
  if (value is! Map<String, dynamic>) {
    return <String, dynamic>{
      'streetNameAndNumber': '',
      'postalCode': 0,
      'town': '',
      'country': '',
    };
  }
  final map = Map<String, dynamic>.from(value);
  final postalRaw = map['postalCode'];
  final postal = postalRaw is int ? postalRaw : int.tryParse('$postalRaw') ?? 0;
  return <String, dynamic>{
    'streetNameAndNumber': map['streetNameAndNumber'] ?? '',
    'postalCode': postal,
    'town': map['town'] ?? '',
    'country': map['country'] ?? '',
  };
}
