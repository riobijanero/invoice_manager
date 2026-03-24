import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';
import 'package:invoice_manager/repositories/invoice_repository.dart';
import 'package:path/path.dart' as path;

/// Exports invoices as CSV (one row per invoice).
///
/// The header schema is designed to remain stable so it can be reused
/// later for CSV import.
class CsvExportService {
  const CsvExportService._();

  static Future<void> exportFromRepository({
    required BuildContext context,
    required InvoiceRepository repository,
  }) async {
    try {
      final invoices = await repository.getAll();
      final savedPath = await exportInvoices(invoices: invoices);
      if (savedPath == null) return;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV exportiert: ${path.basename(savedPath)}'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export fehlgeschlagen: $e')),
      );
    }
  }

  static Future<String?> exportInvoices({
    required List<Invoice> invoices,
  }) async {
    final csv = _buildCsv(invoices);
    final defaultName = 'invoices_export_${DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first}.csv';

    final path = await getSaveLocation(
      suggestedName: defaultName,
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'CSV',
          extensions: <String>['csv'],
        ),
      ],
    );
    if (path == null) return null;

    final outFile = File(path.path);
    await outFile.writeAsString(csv);
    return outFile.path;
  }

  static String _buildCsv(List<Invoice> invoices) {
    const header = <String>[
      'id',
      'createdAt',
      'updatedAt',
      'invoiceNumber',
      'invoiceDate',
      'paidOn',
      'dueDateType',
      'customDueDate',
      'vatRate',
      'discountType',
      'discountValue',
      'contractNumber',
      'introductoryText',
      'clientId',
      'clientCompanyName',
      'clientName',
      'clientStreetNameAndNumber',
      'clientPostalCode',
      'clientTown',
      'clientCountry',
      'senderName',
      'senderStreetNameAndNumber',
      'senderPostalCode',
      'senderTown',
      'senderCountry',
      'senderEmail',
      'senderPhoneNumber',
      'senderWebsite',
      'senderUstId',
      'senderTaxNumber',
      'subtotal',
      'discountAmount',
      'net',
      'vatAmount',
      'gross',
      'itemCount',
      'invoiceJson',
    ];

    final lines = <String>[
      header.map(_csvEscape).join(','),
      ...invoices.map((invoice) {
        final totals = computeTotals(invoice);
        final row = <String>[
          invoice.id,
          invoice.createdAt.toIso8601String(),
          invoice.updatedAt.toIso8601String(),
          invoice.invoiceNumber,
          invoice.invoiceDate.toIso8601String(),
          invoice.paidOn?.toIso8601String() ?? '',
          invoice.dueDateType.name,
          invoice.customDueDate?.toIso8601String() ?? '',
          invoice.vat.toString(),
          invoice.discountType.name,
          invoice.discountValue.toString(),
          invoice.contractNumber,
          invoice.introductoryText,
          invoice.client.clientId,
          invoice.client.companyName,
          invoice.client.name,
          invoice.client.address.streetNameAndNumber,
          invoice.client.address.postalCode.toString(),
          invoice.client.address.town,
          invoice.client.address.country,
          invoice.sender.name,
          invoice.sender.address.streetNameAndNumber,
          invoice.sender.address.postalCode.toString(),
          invoice.sender.address.town,
          invoice.sender.address.country,
          invoice.sender.email,
          invoice.sender.phoneNumber,
          invoice.sender.website,
          invoice.sender.ustId,
          invoice.sender.taxNumber,
          totals.subtotal.toString(),
          totals.discountAmount.toString(),
          totals.net.toString(),
          totals.vat.toString(),
          totals.gross.toString(),
          invoice.invoiceItemList.length.toString(),
          jsonEncode(invoice.toJson()),
        ];
        return row.map(_csvEscape).join(',');
      }),
    ];

    return '${lines.join('\n')}\n';
  }

  static String _csvEscape(String raw) {
    final escaped = raw.replaceAll('"', '""');
    final mustQuote = escaped.contains(',') || escaped.contains('"') || escaped.contains('\n') || escaped.contains('\r');
    return mustQuote ? '"$escaped"' : escaped;
  }
}

