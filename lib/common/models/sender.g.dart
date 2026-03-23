// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SenderImpl _$$SenderImplFromJson(Map<String, dynamic> json) => _$SenderImpl(
      name: json['name'] as String? ?? '',
      jobDescription: json['jobDescription'] as String? ?? '',
      address: json['address'] == null
          ? const Adress()
          : Adress.fromJson(json['address'] as Map<String, dynamic>),
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      website: json['website'] as String? ?? '',
      ustId: json['ustId'] as String? ?? '',
      taxNumber: json['taxNumber'] as String? ?? '',
    );

Map<String, dynamic> _$$SenderImplToJson(_$SenderImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'jobDescription': instance.jobDescription,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'website': instance.website,
      'ustId': instance.ustId,
      'taxNumber': instance.taxNumber,
    };
