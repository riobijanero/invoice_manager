// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_defaults.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppDefaultsImpl _$$AppDefaultsImplFromJson(Map<String, dynamic> json) =>
    _$AppDefaultsImpl(
      lastInvoiceNumber: json['lastInvoiceNumber'] as String? ?? '',
      sender: json['sender'] == null
          ? const Sender()
          : Sender.fromJson(json['sender'] as Map<String, dynamic>),
      client: json['client'] == null
          ? const Client()
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      contractNumber: json['contractNumber'] as String? ?? '',
      bankDetails: json['bankDetails'] == null
          ? null
          : BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>),
      ustId: json['ustId'] as String? ?? '',
      businessTitle:
          json['businessTitle'] as String? ?? 'App und Webentwicklung',
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      discountType:
          $enumDecodeNullable(_$DiscountTypeEnumMap, json['discountType']) ??
              DiscountType.percent,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      dueDateType:
          $enumDecodeNullable(_$DueDateTypeEnumMap, json['dueDateType']) ??
              DueDateType.twoWeeks,
      serviceDescriptionTemplate:
          json['serviceDescriptionTemplate'] as String? ?? '',
    );

const _$DiscountTypeEnumMap = {
  DiscountType.percent: 'percent',
  DiscountType.amount: 'amount',
};

const _$DueDateTypeEnumMap = {
  DueDateType.twoWeeks: 'twoWeeks',
  DueDateType.thirtyDays: 'thirtyDays',
  DueDateType.custom: 'custom',
};
