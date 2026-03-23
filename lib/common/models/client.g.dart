// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClientImpl _$$ClientImplFromJson(Map<String, dynamic> json) => _$ClientImpl(
      companyName: json['companyName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] == null
          ? const Adress()
          : Adress.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ClientImplToJson(_$ClientImpl instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'name': instance.name,
      'address': instance.address,
    };
