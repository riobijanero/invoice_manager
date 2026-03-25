// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      invoiceNumber: json['invoiceNumber'] as String,
      sender: Sender.fromJson(json['sender'] as Map<String, dynamic>),
      client: Client.fromJson(json['client'] as Map<String, dynamic>),
      contractNumber: json['contractNumber'] as String? ?? '',
      bankDetails:
          BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>),
      invoiceDate: DateTime.parse(json['invoiceDate'] as String),
      invoiceItemList: (json['invoiceItemList'] as List<dynamic>?)
              ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <InvoiceItem>[],
      discountType:
          $enumDecodeNullable(_$DiscountTypeEnumMap, json['discountType']) ??
              DiscountType.percent,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      vat: (json['vat'] as num?)?.toDouble() ?? 0.19,
      dueDateType:
          $enumDecodeNullable(_$DueDateTypeEnumMap, json['dueDateType']) ??
              DueDateType.twoWeeks,
      hasQrCode: json['hasQrCode'] as bool? ?? false,
      customDueDate: json['customDueDate'] == null
          ? null
          : DateTime.parse(json['customDueDate'] as String),
      paidOn: json['paidOn'] == null
          ? null
          : DateTime.parse(json['paidOn'] as String),
      introductoryText: json['introductoryText'] as String? ??
          'Sehr geehrte Damen und Herren,\nfür das Erbringen meiner Dienstleistungen berechne ich Ihnen:',
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'invoiceNumber': instance.invoiceNumber,
      'sender': _senderToJson(instance.sender),
      'client': _clientToJson(instance.client),
      'contractNumber': instance.contractNumber,
      'bankDetails': instance.bankDetails,
      'invoiceDate': instance.invoiceDate.toIso8601String(),
      'invoiceItemList': instance.invoiceItemList,
      'discountType': _$DiscountTypeEnumMap[instance.discountType]!,
      'discountValue': instance.discountValue,
      'vat': instance.vat,
      'dueDateType': _$DueDateTypeEnumMap[instance.dueDateType]!,
      'hasQrCode': instance.hasQrCode,
      'customDueDate': instance.customDueDate?.toIso8601String(),
      'paidOn': instance.paidOn?.toIso8601String(),
      'introductoryText': instance.introductoryText,
    };

const _$DiscountTypeEnumMap = {
  DiscountType.percent: 'percent',
  DiscountType.amount: 'amount',
};

const _$DueDateTypeEnumMap = {
  DueDateType.twoWeeks: 'twoWeeks',
  DueDateType.thirtyDays: 'thirtyDays',
  DueDateType.custom: 'custom',
};
