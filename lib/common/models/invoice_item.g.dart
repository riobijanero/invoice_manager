// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceItemImpl _$$InvoiceItemImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceItemImpl(
      serviceMonth: (json['serviceMonth'] as num).toInt(),
      serviceYear: (json['serviceYear'] as num).toInt(),
      hours: (json['hours'] as num).toDouble(),
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      serviceDescription: json['serviceDescription'] as String,
    );

Map<String, dynamic> _$$InvoiceItemImplToJson(_$InvoiceItemImpl instance) =>
    <String, dynamic>{
      'serviceMonth': instance.serviceMonth,
      'serviceYear': instance.serviceYear,
      'hours': instance.hours,
      'hourlyRate': instance.hourlyRate,
      'serviceDescription': instance.serviceDescription,
    };
