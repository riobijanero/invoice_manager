// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HourlyRateServiceItemImpl _$$HourlyRateServiceItemImplFromJson(
        Map<String, dynamic> json) =>
    _$HourlyRateServiceItemImpl(
      serviceMonth: (json['serviceMonth'] as num).toInt(),
      serviceYear: (json['serviceYear'] as num).toInt(),
      hours: (json['hours'] as num).toDouble(),
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      serviceDescription: json['serviceDescription'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$HourlyRateServiceItemImplToJson(
        _$HourlyRateServiceItemImpl instance) =>
    <String, dynamic>{
      'serviceMonth': instance.serviceMonth,
      'serviceYear': instance.serviceYear,
      'hours': instance.hours,
      'hourlyRate': instance.hourlyRate,
      'serviceDescription': instance.serviceDescription,
      'runtimeType': instance.$type,
    };

_$FixedPriceServiceItemImpl _$$FixedPriceServiceItemImplFromJson(
        Map<String, dynamic> json) =>
    _$FixedPriceServiceItemImpl(
      serviceMonth: (json['serviceMonth'] as num).toInt(),
      serviceYear: (json['serviceYear'] as num).toInt(),
      fixedPrice: (json['fixedPrice'] as num).toDouble(),
      serviceDescription: json['serviceDescription'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FixedPriceServiceItemImplToJson(
        _$FixedPriceServiceItemImpl instance) =>
    <String, dynamic>{
      'serviceMonth': instance.serviceMonth,
      'serviceYear': instance.serviceYear,
      'fixedPrice': instance.fixedPrice,
      'serviceDescription': instance.serviceDescription,
      'runtimeType': instance.$type,
    };
