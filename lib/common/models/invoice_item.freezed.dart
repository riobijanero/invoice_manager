// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) {
  return _InvoiceItem.fromJson(json);
}

/// @nodoc
mixin _$InvoiceItem {
  int get position => throw _privateConstructorUsedError;
  int? get serviceMonth => throw _privateConstructorUsedError;
  int? get serviceYear => throw _privateConstructorUsedError;
  DateTime? get serviceDate => throw _privateConstructorUsedError;
  UnitType get unitType => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  String get serviceDescription => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceItemCopyWith<InvoiceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceItemCopyWith<$Res> {
  factory $InvoiceItemCopyWith(
          InvoiceItem value, $Res Function(InvoiceItem) then) =
      _$InvoiceItemCopyWithImpl<$Res, InvoiceItem>;
  @useResult
  $Res call(
      {int position,
      int? serviceMonth,
      int? serviceYear,
      DateTime? serviceDate,
      UnitType unitType,
      double quantity,
      double unitPrice,
      String serviceDescription});
}

/// @nodoc
class _$InvoiceItemCopyWithImpl<$Res, $Val extends InvoiceItem>
    implements $InvoiceItemCopyWith<$Res> {
  _$InvoiceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? serviceMonth = freezed,
    Object? serviceYear = freezed,
    Object? serviceDate = freezed,
    Object? unitType = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? serviceDescription = null,
  }) {
    return _then(_value.copyWith(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      serviceMonth: freezed == serviceMonth
          ? _value.serviceMonth
          : serviceMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceYear: freezed == serviceYear
          ? _value.serviceYear
          : serviceYear // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceDate: freezed == serviceDate
          ? _value.serviceDate
          : serviceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unitType: null == unitType
          ? _value.unitType
          : unitType // ignore: cast_nullable_to_non_nullable
              as UnitType,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      serviceDescription: null == serviceDescription
          ? _value.serviceDescription
          : serviceDescription // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceItemImplCopyWith<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  factory _$$InvoiceItemImplCopyWith(
          _$InvoiceItemImpl value, $Res Function(_$InvoiceItemImpl) then) =
      __$$InvoiceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int position,
      int? serviceMonth,
      int? serviceYear,
      DateTime? serviceDate,
      UnitType unitType,
      double quantity,
      double unitPrice,
      String serviceDescription});
}

/// @nodoc
class __$$InvoiceItemImplCopyWithImpl<$Res>
    extends _$InvoiceItemCopyWithImpl<$Res, _$InvoiceItemImpl>
    implements _$$InvoiceItemImplCopyWith<$Res> {
  __$$InvoiceItemImplCopyWithImpl(
      _$InvoiceItemImpl _value, $Res Function(_$InvoiceItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? serviceMonth = freezed,
    Object? serviceYear = freezed,
    Object? serviceDate = freezed,
    Object? unitType = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? serviceDescription = null,
  }) {
    return _then(_$InvoiceItemImpl(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      serviceMonth: freezed == serviceMonth
          ? _value.serviceMonth
          : serviceMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceYear: freezed == serviceYear
          ? _value.serviceYear
          : serviceYear // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceDate: freezed == serviceDate
          ? _value.serviceDate
          : serviceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unitType: null == unitType
          ? _value.unitType
          : unitType // ignore: cast_nullable_to_non_nullable
              as UnitType,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      serviceDescription: null == serviceDescription
          ? _value.serviceDescription
          : serviceDescription // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceItemImpl extends _InvoiceItem {
  const _$InvoiceItemImpl(
      {this.position = 1,
      this.serviceMonth,
      this.serviceYear,
      this.serviceDate,
      this.unitType = UnitType.hours,
      this.quantity = 0.0,
      this.unitPrice = 0.0,
      required this.serviceDescription})
      : super._();

  factory _$InvoiceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceItemImplFromJson(json);

  @override
  @JsonKey()
  final int position;
  @override
  final int? serviceMonth;
  @override
  final int? serviceYear;
  @override
  final DateTime? serviceDate;
  @override
  @JsonKey()
  final UnitType unitType;
  @override
  @JsonKey()
  final double quantity;
  @override
  @JsonKey()
  final double unitPrice;
  @override
  final String serviceDescription;

  @override
  String toString() {
    return 'InvoiceItem(position: $position, serviceMonth: $serviceMonth, serviceYear: $serviceYear, serviceDate: $serviceDate, unitType: $unitType, quantity: $quantity, unitPrice: $unitPrice, serviceDescription: $serviceDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceItemImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.serviceMonth, serviceMonth) ||
                other.serviceMonth == serviceMonth) &&
            (identical(other.serviceYear, serviceYear) ||
                other.serviceYear == serviceYear) &&
            (identical(other.serviceDate, serviceDate) ||
                other.serviceDate == serviceDate) &&
            (identical(other.unitType, unitType) ||
                other.unitType == unitType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.serviceDescription, serviceDescription) ||
                other.serviceDescription == serviceDescription));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      position,
      serviceMonth,
      serviceYear,
      serviceDate,
      unitType,
      quantity,
      unitPrice,
      serviceDescription);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      __$$InvoiceItemImplCopyWithImpl<_$InvoiceItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceItemImplToJson(
      this,
    );
  }
}

abstract class _InvoiceItem extends InvoiceItem {
  const factory _InvoiceItem(
      {final int position,
      final int? serviceMonth,
      final int? serviceYear,
      final DateTime? serviceDate,
      final UnitType unitType,
      final double quantity,
      final double unitPrice,
      required final String serviceDescription}) = _$InvoiceItemImpl;
  const _InvoiceItem._() : super._();

  factory _InvoiceItem.fromJson(Map<String, dynamic> json) =
      _$InvoiceItemImpl.fromJson;

  @override
  int get position;
  @override
  int? get serviceMonth;
  @override
  int? get serviceYear;
  @override
  DateTime? get serviceDate;
  @override
  UnitType get unitType;
  @override
  double get quantity;
  @override
  double get unitPrice;
  @override
  String get serviceDescription;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
