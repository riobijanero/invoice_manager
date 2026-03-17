// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankDetailsImpl _$$BankDetailsImplFromJson(Map<String, dynamic> json) =>
    _$BankDetailsImpl(
      accountHolder: json['accountHolder'] as String,
      institution: json['institution'] as String,
      iban: json['iban'] as String,
      bic: json['bic'] as String,
    );

Map<String, dynamic> _$$BankDetailsImplToJson(_$BankDetailsImpl instance) =>
    <String, dynamic>{
      'accountHolder': instance.accountHolder,
      'institution': instance.institution,
      'iban': instance.iban,
      'bic': instance.bic,
    };
