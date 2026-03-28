// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_service_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SavedServicePreset _$SavedServicePresetFromJson(Map<String, dynamic> json) {
  return _SavedServicePreset.fromJson(json);
}

/// @nodoc
mixin _$SavedServicePreset {
  String get description => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  UnitType get unitType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SavedServicePresetCopyWith<SavedServicePreset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedServicePresetCopyWith<$Res> {
  factory $SavedServicePresetCopyWith(
          SavedServicePreset value, $Res Function(SavedServicePreset) then) =
      _$SavedServicePresetCopyWithImpl<$Res, SavedServicePreset>;
  @useResult
  $Res call({String description, double unitPrice, UnitType unitType});
}

/// @nodoc
class _$SavedServicePresetCopyWithImpl<$Res, $Val extends SavedServicePreset>
    implements $SavedServicePresetCopyWith<$Res> {
  _$SavedServicePresetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? unitPrice = null,
    Object? unitType = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      unitType: null == unitType
          ? _value.unitType
          : unitType // ignore: cast_nullable_to_non_nullable
              as UnitType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedServicePresetImplCopyWith<$Res>
    implements $SavedServicePresetCopyWith<$Res> {
  factory _$$SavedServicePresetImplCopyWith(_$SavedServicePresetImpl value,
          $Res Function(_$SavedServicePresetImpl) then) =
      __$$SavedServicePresetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description, double unitPrice, UnitType unitType});
}

/// @nodoc
class __$$SavedServicePresetImplCopyWithImpl<$Res>
    extends _$SavedServicePresetCopyWithImpl<$Res, _$SavedServicePresetImpl>
    implements _$$SavedServicePresetImplCopyWith<$Res> {
  __$$SavedServicePresetImplCopyWithImpl(_$SavedServicePresetImpl _value,
      $Res Function(_$SavedServicePresetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? unitPrice = null,
    Object? unitType = null,
  }) {
    return _then(_$SavedServicePresetImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      unitType: null == unitType
          ? _value.unitType
          : unitType // ignore: cast_nullable_to_non_nullable
              as UnitType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedServicePresetImpl implements _SavedServicePreset {
  const _$SavedServicePresetImpl(
      {this.description = '',
      this.unitPrice = 0.0,
      this.unitType = UnitType.hours});

  factory _$SavedServicePresetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedServicePresetImplFromJson(json);

  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final double unitPrice;
  @override
  @JsonKey()
  final UnitType unitType;

  @override
  String toString() {
    return 'SavedServicePreset(description: $description, unitPrice: $unitPrice, unitType: $unitType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedServicePresetImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.unitType, unitType) ||
                other.unitType == unitType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, description, unitPrice, unitType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedServicePresetImplCopyWith<_$SavedServicePresetImpl> get copyWith =>
      __$$SavedServicePresetImplCopyWithImpl<_$SavedServicePresetImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedServicePresetImplToJson(
      this,
    );
  }
}

abstract class _SavedServicePreset implements SavedServicePreset {
  const factory _SavedServicePreset(
      {final String description,
      final double unitPrice,
      final UnitType unitType}) = _$SavedServicePresetImpl;

  factory _SavedServicePreset.fromJson(Map<String, dynamic> json) =
      _$SavedServicePresetImpl.fromJson;

  @override
  String get description;
  @override
  double get unitPrice;
  @override
  UnitType get unitType;
  @override
  @JsonKey(ignore: true)
  _$$SavedServicePresetImplCopyWith<_$SavedServicePresetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
