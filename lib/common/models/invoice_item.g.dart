// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceItemImpl _$$InvoiceItemImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceItemImpl(
      position: (json['position'] as num?)?.toInt() ?? 1,
      serviceMonth: (json['serviceMonth'] as num?)?.toInt(),
      serviceYear: (json['serviceYear'] as num?)?.toInt(),
      serviceDate: json['serviceDate'] == null
          ? null
          : DateTime.parse(json['serviceDate'] as String),
      unitType: $enumDecodeNullable(_$UnitTypeEnumMap, json['unitType']) ??
          UnitType.hours,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      serviceDescription: json['serviceDescription'] as String,
    );

Map<String, dynamic> _$$InvoiceItemImplToJson(_$InvoiceItemImpl instance) =>
    <String, dynamic>{
      'position': instance.position,
      'serviceMonth': instance.serviceMonth,
      'serviceYear': instance.serviceYear,
      'serviceDate': instance.serviceDate?.toIso8601String(),
      'unitType': _$UnitTypeEnumMap[instance.unitType]!,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'serviceDescription': instance.serviceDescription,
    };

const _$UnitTypeEnumMap = {
  UnitType.hours: 'hours',
  UnitType.minutes: 'minutes',
  UnitType.amount: 'amount',
};
