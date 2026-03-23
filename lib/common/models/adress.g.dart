// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdressImpl _$$AdressImplFromJson(Map<String, dynamic> json) => _$AdressImpl(
      streetNameAndNumber: json['streetNameAndNumber'] as String? ?? '',
      town: json['town'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postalCode: (json['postalCode'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AdressImplToJson(_$AdressImpl instance) =>
    <String, dynamic>{
      'streetNameAndNumber': instance.streetNameAndNumber,
      'town': instance.town,
      'country': instance.country,
      'postalCode': instance.postalCode,
    };
