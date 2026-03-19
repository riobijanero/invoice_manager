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
      serviceMonth: (json['serviceMonth'] as num).toInt(),
      serviceYear: (json['serviceYear'] as num).toInt(),
      hours: (json['hours'] as num).toDouble(),
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      discountType:
          $enumDecodeNullable(_$DiscountTypeEnumMap, json['discountType']) ??
              DiscountType.percent,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      dueDateType:
          $enumDecodeNullable(_$DueDateTypeEnumMap, json['dueDateType']) ??
              DueDateType.twoWeeks,
      customDueDate: json['customDueDate'] == null
          ? null
          : DateTime.parse(json['customDueDate'] as String),
      paidOn: json['paidOn'] == null
          ? null
          : DateTime.parse(json['paidOn'] as String),
      jobDescription: json['jobDescription'] as String? ?? '',
      serviceDescription: json['serviceDescription'] as String,
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
      'serviceMonth': instance.serviceMonth,
      'serviceYear': instance.serviceYear,
      'hours': instance.hours,
      'hourlyRate': instance.hourlyRate,
      'discountType': _$DiscountTypeEnumMap[instance.discountType]!,
      'discountValue': instance.discountValue,
      'dueDateType': _$DueDateTypeEnumMap[instance.dueDateType]!,
      'customDueDate': instance.customDueDate?.toIso8601String(),
      'paidOn': instance.paidOn?.toIso8601String(),
      'jobDescription': instance.jobDescription,
      'serviceDescription': instance.serviceDescription,
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
