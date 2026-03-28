// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_service_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedServicePresetImpl _$$SavedServicePresetImplFromJson(
        Map<String, dynamic> json) =>
    _$SavedServicePresetImpl(
      description: json['description'] as String? ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      unitType: $enumDecodeNullable(_$UnitTypeEnumMap, json['unitType']) ??
          UnitType.hours,
    );

Map<String, dynamic> _$$SavedServicePresetImplToJson(
        _$SavedServicePresetImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'unitPrice': instance.unitPrice,
      'unitType': _$UnitTypeEnumMap[instance.unitType]!,
    };

const _$UnitTypeEnumMap = {
  UnitType.hours: 'hours',
  UnitType.minutes: 'minutes',
  UnitType.amount: 'amount',
};
