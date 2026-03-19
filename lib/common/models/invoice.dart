import 'package:freezed_annotation/freezed_annotation.dart';

import 'bank_details.dart';
import 'client.dart';
import 'discount_type.dart';
import 'due_date_type.dart';
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
    required int serviceMonth,
    required int serviceYear,
    required double hours,
    required double hourlyRate,
    @Default(DiscountType.percent) DiscountType discountType,
    @Default(0.0) double discountValue,
    @Default(DueDateType.twoWeeks) DueDateType dueDateType,
    DateTime? customDueDate,
    DateTime? paidOn,
    @Default('') String jobDescription,
    required String serviceDescription,
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
