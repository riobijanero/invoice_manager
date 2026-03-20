import 'package:freezed_annotation/freezed_annotation.dart';

import 'bank_details.dart';
import 'client.dart';
import 'discount_type.dart';
import 'due_date_type.dart';
import 'invoice_item.dart';
import 'sender.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String invoiceNumber,
    // ignore: invalid_annotation_target
    @JsonKey(toJson: _senderToJson) required Sender sender,
    // ignore: invalid_annotation_target
    @JsonKey(toJson: _clientToJson) required Client client,
    @Default('') String contractNumber,
    required BankDetails bankDetails,
    required DateTime invoiceDate,
    required InvoiceItem invoiceItem,
    @Default(DiscountType.percent) DiscountType discountType,
    @Default(0.0) double discountValue,
    @Default(DueDateType.twoWeeks) DueDateType dueDateType,
    DateTime? customDueDate,
    DateTime? paidOn,
    @Default(
      'Sehr geehrte Damen und Herren,\nfür das Erbringen meiner Dienstleistungen berechne ich Ihnen:',
    )
    String introductoryText,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(_migrateInvoiceJson(json));

  /// Supports legacy JSON with senderAddress/clientAddress strings.
  static Map<String, dynamic> _migrateInvoiceJson(Map<String, dynamic> json) {
    final out = Map<String, dynamic>.from(json);
    if (out['sender'] == null && out['senderAddress'] != null) {
      out['sender'] = _senderFromLegacyString(out['senderAddress'] as String? ?? '');
    }
    if (out['client'] == null && out['clientAddress'] != null) {
      out['client'] = _clientFromLegacyString(out['clientAddress'] as String? ?? '');
    }

    // Legacy schema: serviceMonth/serviceYear/hours/hourlyRate/serviceDescription
    // were top-level fields on Invoice. Now they live in InvoiceItem.
    if (out['invoiceItem'] == null) {
      final serviceDescription = out['serviceDescription'] as String? ?? '';
      out['invoiceItem'] = <String, dynamic>{
        'serviceMonth': out['serviceMonth'] as int? ?? DateTime.now().month,
        'serviceYear': out['serviceYear'] as int? ?? DateTime.now().year,
        'hours': (out['hours'] as num?)?.toDouble() ?? 0.0,
        'hourlyRate': (out['hourlyRate'] as num?)?.toDouble() ?? 0.0,
        'serviceDescription': serviceDescription,
      };
      // Optional: keep old keys around, but they won't be used by the new model.
    }
    return out;
  }

  static Map<String, dynamic> _senderFromLegacyString(String s) {
    final lines = s.split(RegExp(r'[\r\n]+'));
    if (lines.isEmpty) return const Sender().toJson();
    return Sender(name: lines.first.trim(), address: lines.skip(1).join('\n').trim()).toJson();
  }

  static Map<String, dynamic> _clientFromLegacyString(String s) {
    final lines = s.split(RegExp(r'[\r\n]+'));
    if (lines.isEmpty) return const Client().toJson();
    return Client(name: lines.first.trim(), address: lines.skip(1).join('\n').trim()).toJson();
  }
}

Map<String, dynamic> _senderToJson(Sender s) => s.toJson();
Map<String, dynamic> _clientToJson(Client c) => c.toJson();
