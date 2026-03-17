// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BankDetails _$BankDetailsFromJson(Map<String, dynamic> json) {
  return _BankDetails.fromJson(json);
}

/// @nodoc
mixin _$BankDetails {
  String get accountHolder => throw _privateConstructorUsedError;
  String get institution => throw _privateConstructorUsedError;
  String get iban => throw _privateConstructorUsedError;
  String get bic => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BankDetailsCopyWith<BankDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankDetailsCopyWith<$Res> {
  factory $BankDetailsCopyWith(
          BankDetails value, $Res Function(BankDetails) then) =
      _$BankDetailsCopyWithImpl<$Res, BankDetails>;
  @useResult
  $Res call(
      {String accountHolder, String institution, String iban, String bic});
}

/// @nodoc
class _$BankDetailsCopyWithImpl<$Res, $Val extends BankDetails>
    implements $BankDetailsCopyWith<$Res> {
  _$BankDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountHolder = null,
    Object? institution = null,
    Object? iban = null,
    Object? bic = null,
  }) {
    return _then(_value.copyWith(
      accountHolder: null == accountHolder
          ? _value.accountHolder
          : accountHolder // ignore: cast_nullable_to_non_nullable
              as String,
      institution: null == institution
          ? _value.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as String,
      iban: null == iban
          ? _value.iban
          : iban // ignore: cast_nullable_to_non_nullable
              as String,
      bic: null == bic
          ? _value.bic
          : bic // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankDetailsImplCopyWith<$Res>
    implements $BankDetailsCopyWith<$Res> {
  factory _$$BankDetailsImplCopyWith(
          _$BankDetailsImpl value, $Res Function(_$BankDetailsImpl) then) =
      __$$BankDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountHolder, String institution, String iban, String bic});
}

/// @nodoc
class __$$BankDetailsImplCopyWithImpl<$Res>
    extends _$BankDetailsCopyWithImpl<$Res, _$BankDetailsImpl>
    implements _$$BankDetailsImplCopyWith<$Res> {
  __$$BankDetailsImplCopyWithImpl(
      _$BankDetailsImpl _value, $Res Function(_$BankDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountHolder = null,
    Object? institution = null,
    Object? iban = null,
    Object? bic = null,
  }) {
    return _then(_$BankDetailsImpl(
      accountHolder: null == accountHolder
          ? _value.accountHolder
          : accountHolder // ignore: cast_nullable_to_non_nullable
              as String,
      institution: null == institution
          ? _value.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as String,
      iban: null == iban
          ? _value.iban
          : iban // ignore: cast_nullable_to_non_nullable
              as String,
      bic: null == bic
          ? _value.bic
          : bic // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankDetailsImpl implements _BankDetails {
  const _$BankDetailsImpl(
      {required this.accountHolder,
      required this.institution,
      required this.iban,
      required this.bic});

  factory _$BankDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankDetailsImplFromJson(json);

  @override
  final String accountHolder;
  @override
  final String institution;
  @override
  final String iban;
  @override
  final String bic;

  @override
  String toString() {
    return 'BankDetails(accountHolder: $accountHolder, institution: $institution, iban: $iban, bic: $bic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankDetailsImpl &&
            (identical(other.accountHolder, accountHolder) ||
                other.accountHolder == accountHolder) &&
            (identical(other.institution, institution) ||
                other.institution == institution) &&
            (identical(other.iban, iban) || other.iban == iban) &&
            (identical(other.bic, bic) || other.bic == bic));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accountHolder, institution, iban, bic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BankDetailsImplCopyWith<_$BankDetailsImpl> get copyWith =>
      __$$BankDetailsImplCopyWithImpl<_$BankDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankDetailsImplToJson(
      this,
    );
  }
}

abstract class _BankDetails implements BankDetails {
  const factory _BankDetails(
      {required final String accountHolder,
      required final String institution,
      required final String iban,
      required final String bic}) = _$BankDetailsImpl;

  factory _BankDetails.fromJson(Map<String, dynamic> json) =
      _$BankDetailsImpl.fromJson;

  @override
  String get accountHolder;
  @override
  String get institution;
  @override
  String get iban;
  @override
  String get bic;
  @override
  @JsonKey(ignore: true)
  _$$BankDetailsImplCopyWith<_$BankDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
