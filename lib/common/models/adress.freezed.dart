// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Adress _$AdressFromJson(Map<String, dynamic> json) {
  return _Adress.fromJson(json);
}

/// @nodoc
mixin _$Adress {
  String get streetNameAndNumber => throw _privateConstructorUsedError;
  String get town => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  int get postalCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdressCopyWith<Adress> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdressCopyWith<$Res> {
  factory $AdressCopyWith(Adress value, $Res Function(Adress) then) =
      _$AdressCopyWithImpl<$Res, Adress>;
  @useResult
  $Res call(
      {String streetNameAndNumber,
      String town,
      String country,
      int postalCode});
}

/// @nodoc
class _$AdressCopyWithImpl<$Res, $Val extends Adress>
    implements $AdressCopyWith<$Res> {
  _$AdressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streetNameAndNumber = null,
    Object? town = null,
    Object? country = null,
    Object? postalCode = null,
  }) {
    return _then(_value.copyWith(
      streetNameAndNumber: null == streetNameAndNumber
          ? _value.streetNameAndNumber
          : streetNameAndNumber // ignore: cast_nullable_to_non_nullable
              as String,
      town: null == town
          ? _value.town
          : town // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdressImplCopyWith<$Res> implements $AdressCopyWith<$Res> {
  factory _$$AdressImplCopyWith(
          _$AdressImpl value, $Res Function(_$AdressImpl) then) =
      __$$AdressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String streetNameAndNumber,
      String town,
      String country,
      int postalCode});
}

/// @nodoc
class __$$AdressImplCopyWithImpl<$Res>
    extends _$AdressCopyWithImpl<$Res, _$AdressImpl>
    implements _$$AdressImplCopyWith<$Res> {
  __$$AdressImplCopyWithImpl(
      _$AdressImpl _value, $Res Function(_$AdressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streetNameAndNumber = null,
    Object? town = null,
    Object? country = null,
    Object? postalCode = null,
  }) {
    return _then(_$AdressImpl(
      streetNameAndNumber: null == streetNameAndNumber
          ? _value.streetNameAndNumber
          : streetNameAndNumber // ignore: cast_nullable_to_non_nullable
              as String,
      town: null == town
          ? _value.town
          : town // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdressImpl extends _Adress {
  const _$AdressImpl(
      {this.streetNameAndNumber = '',
      this.town = '',
      this.country = '',
      this.postalCode = 0})
      : super._();

  factory _$AdressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdressImplFromJson(json);

  @override
  @JsonKey()
  final String streetNameAndNumber;
  @override
  @JsonKey()
  final String town;
  @override
  @JsonKey()
  final String country;
  @override
  @JsonKey()
  final int postalCode;

  @override
  String toString() {
    return 'Adress(streetNameAndNumber: $streetNameAndNumber, town: $town, country: $country, postalCode: $postalCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdressImpl &&
            (identical(other.streetNameAndNumber, streetNameAndNumber) ||
                other.streetNameAndNumber == streetNameAndNumber) &&
            (identical(other.town, town) || other.town == town) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, streetNameAndNumber, town, country, postalCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdressImplCopyWith<_$AdressImpl> get copyWith =>
      __$$AdressImplCopyWithImpl<_$AdressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdressImplToJson(
      this,
    );
  }
}

abstract class _Adress extends Adress {
  const factory _Adress(
      {final String streetNameAndNumber,
      final String town,
      final String country,
      final int postalCode}) = _$AdressImpl;
  const _Adress._() : super._();

  factory _Adress.fromJson(Map<String, dynamic> json) = _$AdressImpl.fromJson;

  @override
  String get streetNameAndNumber;
  @override
  String get town;
  @override
  String get country;
  @override
  int get postalCode;
  @override
  @JsonKey(ignore: true)
  _$$AdressImplCopyWith<_$AdressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
