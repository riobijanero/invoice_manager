import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:invoice_manager/common/models/adress.dart';
import 'package:invoice_manager/common/models/bank_details.dart';
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/models/sender.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';
import 'package:invoice_manager/repositories/invoice_repository.dart';

class CsvImportConflict {
  const CsvImportConflict({
    required this.existing,
    required this.imported,
  });

  final Invoice existing;
  final Invoice imported;
}

class CsvImportPreview {
  const CsvImportPreview({
    required this.importedPath,
    required this.newInvoices,
    required this.conflicts,
  });

  final String importedPath;
  final List<Invoice> newInvoices;
  final List<CsvImportConflict> conflicts;
}

class CsvImportService {
  const CsvImportService._();

  static Future<void> importIntoRepository({
    required BuildContext context,
    required InvoiceRepository repository,
    required VoidCallback onDataChanged,
  }) async {
    try {
      final existing = await repository.getAll();
      final preview = await pickAndAnalyze(existingInvoices: existing);
      if (preview == null) return;

      final byId = <String, Invoice>{for (final invoice in existing) invoice.id: invoice};
      var addedCount = 0;
      var replacedCount = 0;

      for (final invoice in preview.newInvoices) {
        if (!byId.containsKey(invoice.id)) {
          byId[invoice.id] = invoice;
          addedCount++;
        }
      }

      for (final conflict in preview.conflicts) {
        if (!context.mounted) return;
        final choice = await _askConflictResolution(context, conflict);
        if (choice == null) continue;
        if (choice == _ConflictChoice.useImported) {
          byId[conflict.imported.id] = conflict.imported;
          replacedCount++;
        }
      }

      await repository.replaceAll(byId.values.toList());
      onDataChanged();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Import abgeschlossen: $addedCount hinzugefügt, $replacedCount ersetzt.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import fehlgeschlagen: $e')),
      );
    }
  }

  static Future<CsvImportPreview?> pickAndAnalyze({
    required List<Invoice> existingInvoices,
  }) async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'CSV',
          extensions: <String>['csv'],
        ),
      ],
    );
    if (file == null) return null;

    final csv = await File(file.path).readAsString();
    final importedInvoices = _parseInvoicesFromCsv(csv);

    final existingById = <String, Invoice>{for (final i in existingInvoices) i.id: i};
    final seenImportedIds = <String>{};
    final newInvoices = <Invoice>[];
    final conflicts = <CsvImportConflict>[];

    for (final imported in importedInvoices) {
      if (imported.id.trim().isEmpty) continue;
      if (!seenImportedIds.add(imported.id)) continue;
      final existing = existingById[imported.id];
      if (existing == null) {
        newInvoices.add(imported);
        continue;
      }
      if (existing.updatedAt.isAtSameMomentAs(imported.updatedAt)) {
        continue;
      }
      conflicts.add(CsvImportConflict(existing: existing, imported: imported));
    }

    return CsvImportPreview(
      importedPath: file.path,
      newInvoices: newInvoices,
      conflicts: conflicts,
    );
  }

  static List<Invoice> _parseInvoicesFromCsv(String csv) {
    final rows = _parseCsvRows(csv);
    if (rows.length < 2) return const <Invoice>[];
    final header = rows.first;
    final indexByName = <String, int>{for (var i = 0; i < header.length; i++) header[i]: i};

    String value(List<String> row, String key) {
      final idx = indexByName[key];
      if (idx == null || idx < 0 || idx >= row.length) return '';
      return row[idx].trim();
    }

    final out = <Invoice>[];
    for (final row in rows.skip(1)) {
      if (row.every((v) => v.trim().isEmpty)) continue;

      final invoiceJsonRaw = value(row, 'invoiceJson');
      if (invoiceJsonRaw.isNotEmpty) {
        try {
          final decoded = jsonDecode(invoiceJsonRaw);
          if (decoded is Map<String, dynamic>) {
            out.add(Invoice.fromJson(decoded));
            continue;
          }
        } catch (_) {
          // fall through to compatibility parser
        }
      }

      final id = value(row, 'id');
      if (id.isEmpty) continue;
      final createdAt = DateTime.tryParse(value(row, 'createdAt')) ?? DateTime.now();
      final updatedAt = DateTime.tryParse(value(row, 'updatedAt')) ?? createdAt;
      final invoiceDate = DateTime.tryParse(value(row, 'invoiceDate')) ?? createdAt;
      final paidOn = DateTime.tryParse(value(row, 'paidOn'));
      final customDueDate = DateTime.tryParse(value(row, 'customDueDate'));
      final dueDateType = _parseDueDateType(value(row, 'dueDateType'));
      final discountType = _parseDiscountType(value(row, 'discountType'));
      final discountValue = double.tryParse(value(row, 'discountValue').replaceFirst(',', '.')) ?? 0.0;
      final vat = double.tryParse(value(row, 'vatRate').replaceFirst(',', '.')) ?? 0.19;

      out.add(
        Invoice(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          invoiceNumber: value(row, 'invoiceNumber'),
          sender: Sender(
            name: value(row, 'senderName'),
            address: Adress(
              streetNameAndNumber: value(row, 'senderStreetNameAndNumber'),
              postalCode: int.tryParse(value(row, 'senderPostalCode')) ?? 0,
              town: value(row, 'senderTown'),
              country: value(row, 'senderCountry'),
            ),
            phoneNumber: value(row, 'senderPhoneNumber'),
            email: value(row, 'senderEmail'),
            website: value(row, 'senderWebsite'),
            ustId: value(row, 'senderUstId'),
            taxNumber: value(row, 'senderTaxNumber'),
          ),
          client: Client(
            clientId: value(row, 'clientId'),
            companyName: value(row, 'clientCompanyName'),
            name: value(row, 'clientName'),
            address: Adress(
              streetNameAndNumber: value(row, 'clientStreetNameAndNumber'),
              postalCode: int.tryParse(value(row, 'clientPostalCode')) ?? 0,
              town: value(row, 'clientTown'),
              country: value(row, 'clientCountry'),
            ),
          ),
          contractNumber: value(row, 'contractNumber'),
          bankDetails: const BankDetails(
            accountHolder: '',
            institution: '',
            iban: '',
            bic: '',
          ),
          invoiceDate: invoiceDate,
          invoiceItemList: const [],
          discountType: discountType,
          discountValue: discountValue,
          vat: vat,
          dueDateType: dueDateType,
          customDueDate: customDueDate,
          paidOn: paidOn,
          introductoryText: value(row, 'introductoryText').isEmpty
              ? 'Sehr geehrte Damen und Herren,\nfür das Erbringen meiner Dienstleistungen berechne ich Ihnen:'
              : value(row, 'introductoryText'),
        ),
      );
    }
    return out;
  }

  static List<List<String>> _parseCsvRows(String text) {
    final rows = <List<String>>[];
    final row = <String>[];
    final cell = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (ch == '"') {
        if (inQuotes && i + 1 < text.length && text[i + 1] == '"') {
          cell.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
        continue;
      }
      if (ch == ',' && !inQuotes) {
        row.add(cell.toString());
        cell.clear();
        continue;
      }
      if ((ch == '\n' || ch == '\r') && !inQuotes) {
        if (ch == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
        row.add(cell.toString());
        cell.clear();
        if (row.any((v) => v.isNotEmpty)) {
          rows.add(List<String>.from(row));
        }
        row.clear();
        continue;
      }
      cell.write(ch);
    }

    if (cell.isNotEmpty || row.isNotEmpty) {
      row.add(cell.toString());
      if (row.any((v) => v.isNotEmpty)) {
        rows.add(List<String>.from(row));
      }
    }
    return rows;
  }

  static DiscountType _parseDiscountType(String raw) {
    for (final type in DiscountType.values) {
      if (type.name == raw) return type;
    }
    return DiscountType.percent;
  }

  static DueDateType _parseDueDateType(String raw) {
    for (final type in DueDateType.values) {
      if (type.name == raw) return type;
    }
    return DueDateType.twoWeeks;
  }

  static Future<_ConflictChoice?> _askConflictResolution(
    BuildContext context,
    CsvImportConflict conflict,
  ) {
    final existingIsNewer = conflict.existing.updatedAt.isAfter(conflict.imported.updatedAt);
    final newerLabel = existingIsNewer ? 'Bereits gespeichert' : 'Import-Datei';
    final differences = _describeDifferences(conflict.existing, conflict.imported);
    return showDialog<_ConflictChoice>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konflikt bei Rechnungsdaten'),
        content: SingleChildScrollView(
          child: Text(
            'Rechnung ${conflict.existing.invoiceNumber} (${conflict.existing.id}) existiert bereits.\n'
            'Neuere Version: $newerLabel.\n\n'
            'Bereits gespeichert: ${conflict.existing.updatedAt.toIso8601String()}\n'
            'Import-Datei: ${conflict.imported.updatedAt.toIso8601String()}\n\n'
            'Unterschiede:\n${differences.map((d) => '- $d').join('\n')}\n\n'
            'Welche Version möchten Sie behalten?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_ConflictChoice.keepExisting),
            child: const Text('Bereits gespeicherte behalten'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_ConflictChoice.useImported),
            child: const Text('Import-Version verwenden'),
          ),
        ],
      ),
    );
  }

  static List<String> _describeDifferences(Invoice existing, Invoice imported) {
    final diffs = <String>[];
    void addIfDifferent(String label, Object? a, Object? b) {
      if ('$a' != '$b') {
        diffs.add('$label: "${_short(a)}" -> "${_short(b)}"');
      }
    }

    addIfDifferent('Rechnungsnummer', existing.invoiceNumber, imported.invoiceNumber);
    addIfDifferent('Rechnungsdatum', existing.invoiceDate.toIso8601String(), imported.invoiceDate.toIso8601String());
    addIfDifferent('Bezahlt am', existing.paidOn?.toIso8601String() ?? '', imported.paidOn?.toIso8601String() ?? '');
    addIfDifferent('Kunde (Firma)', existing.client.companyName, imported.client.companyName);
    addIfDifferent('Kunde (Name)', existing.client.name, imported.client.name);
    addIfDifferent('Kundennummer', existing.client.clientId, imported.client.clientId);
    addIfDifferent('Vertragsnummer', existing.contractNumber, imported.contractNumber);
    addIfDifferent('MwSt', existing.vat, imported.vat);
    addIfDifferent('Stundensatz', _hourlyRatesSummary(existing), _hourlyRatesSummary(imported));
    addIfDifferent('Rabatt-Typ', existing.discountType.name, imported.discountType.name);
    addIfDifferent('Rabatt-Wert', existing.discountValue, imported.discountValue);
    addIfDifferent('Fälligkeit', existing.dueDateType.name, imported.dueDateType.name);
    addIfDifferent('Positionen', existing.invoiceItemList.length, imported.invoiceItemList.length);
    addIfDifferent(
      'Rechnungssumme (brutto)',
      computeTotals(existing).gross.toStringAsFixed(2),
      computeTotals(imported).gross.toStringAsFixed(2),
    );
    addIfDifferent('Einleitungstext', existing.introductoryText, imported.introductoryText);

    if (diffs.isEmpty) {
      diffs.add('Keine feldbasierten Unterschiede erkannt (nur Zeitstempel unterscheidet sich).');
    }
    return diffs;
  }

  static String _short(Object? value) {
    final s = (value ?? '').toString().replaceAll('\n', ' ').trim();
    if (s.length <= 80) return s;
    return '${s.substring(0, 77)}...';
  }

  static String _hourlyRatesSummary(Invoice invoice) {
    final rates = invoice.invoiceItemList
        .where((item) => item.unitType == UnitType.hours)
        .map((item) => item.unitPrice.toStringAsFixed(2))
        .toSet()
        .toList()
      ..sort();
    if (rates.isEmpty) return '';
    return rates.join(', ');
  }
}

enum _ConflictChoice {
  keepExisting,
  useImported,
}
