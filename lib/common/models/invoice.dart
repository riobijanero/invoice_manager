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
    @Default(<InvoiceItem>[]) List<InvoiceItem> invoiceItemList,
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

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}

Map<String, dynamic> _senderToJson(Sender s) => s.toJson();
Map<String, dynamic> _clientToJson(Client c) => c.toJson();
