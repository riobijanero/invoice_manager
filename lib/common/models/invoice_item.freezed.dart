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
  switch (json['runtimeType']) {
    case 'hourlyRateService':
      return _HourlyRateServiceItem.fromJson(json);
    case 'fixedPriceService':
      return _FixedPriceServiceItem.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'InvoiceItem',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$InvoiceItem {
  int? get serviceMonth => throw _privateConstructorUsedError;
  int? get serviceYear => throw _privateConstructorUsedError;
  String get serviceDescription => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)
        hourlyRateService,
    required TResult Function(int? serviceMonth, int? serviceYear,
            double fixedPrice, String serviceDescription)
        fixedPriceService,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)?
        hourlyRateService,
    TResult? Function(int? serviceMonth, int? serviceYear, double fixedPrice,
            String serviceDescription)?
        fixedPriceService,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)?
        hourlyRateService,
    TResult Function(int? serviceMonth, int? serviceYear, double fixedPrice,
            String serviceDescription)?
        fixedPriceService,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_HourlyRateServiceItem value) hourlyRateService,
    required TResult Function(_FixedPriceServiceItem value) fixedPriceService,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_HourlyRateServiceItem value)? hourlyRateService,
    TResult? Function(_FixedPriceServiceItem value)? fixedPriceService,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HourlyRateServiceItem value)? hourlyRateService,
    TResult Function(_FixedPriceServiceItem value)? fixedPriceService,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
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
  $Res call({int? serviceMonth, int? serviceYear, String serviceDescription});
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
    Object? serviceMonth = freezed,
    Object? serviceYear = freezed,
    Object? serviceDescription = null,
  }) {
    return _then(_value.copyWith(
      serviceMonth: freezed == serviceMonth
          ? _value.serviceMonth
          : serviceMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceYear: freezed == serviceYear
          ? _value.serviceYear
          : serviceYear // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceDescription: null == serviceDescription
          ? _value.serviceDescription
          : serviceDescription // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HourlyRateServiceItemImplCopyWith<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  factory _$$HourlyRateServiceItemImplCopyWith(
          _$HourlyRateServiceItemImpl value,
          $Res Function(_$HourlyRateServiceItemImpl) then) =
      __$$HourlyRateServiceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? serviceMonth,
      int? serviceYear,
      double hours,
      double hourlyRate,
      String serviceDescription});
}

/// @nodoc
class __$$HourlyRateServiceItemImplCopyWithImpl<$Res>
    extends _$InvoiceItemCopyWithImpl<$Res, _$HourlyRateServiceItemImpl>
    implements _$$HourlyRateServiceItemImplCopyWith<$Res> {
  __$$HourlyRateServiceItemImplCopyWithImpl(_$HourlyRateServiceItemImpl _value,
      $Res Function(_$HourlyRateServiceItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceMonth = freezed,
    Object? serviceYear = freezed,
    Object? hours = null,
    Object? hourlyRate = null,
    Object? serviceDescription = null,
  }) {
    return _then(_$HourlyRateServiceItemImpl(
      serviceMonth: freezed == serviceMonth
          ? _value.serviceMonth
          : serviceMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceYear: freezed == serviceYear
          ? _value.serviceYear
          : serviceYear // ignore: cast_nullable_to_non_nullable
              as int?,
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as double,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
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
class _$HourlyRateServiceItemImpl extends _HourlyRateServiceItem {
  const _$HourlyRateServiceItemImpl(
      {this.serviceMonth,
      this.serviceYear,
      required this.hours,
      required this.hourlyRate,
      required this.serviceDescription,
      final String? $type})
      : $type = $type ?? 'hourlyRateService',
        super._();

  factory _$HourlyRateServiceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$HourlyRateServiceItemImplFromJson(json);

  @override
  final int? serviceMonth;
  @override
  final int? serviceYear;
  @override
  final double hours;
  @override
  final double hourlyRate;
  @override
  final String serviceDescription;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'InvoiceItem.hourlyRateService(serviceMonth: $serviceMonth, serviceYear: $serviceYear, hours: $hours, hourlyRate: $hourlyRate, serviceDescription: $serviceDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlyRateServiceItemImpl &&
            (identical(other.serviceMonth, serviceMonth) ||
                other.serviceMonth == serviceMonth) &&
            (identical(other.serviceYear, serviceYear) ||
                other.serviceYear == serviceYear) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.serviceDescription, serviceDescription) ||
                other.serviceDescription == serviceDescription));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, serviceMonth, serviceYear, hours,
      hourlyRate, serviceDescription);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlyRateServiceItemImplCopyWith<_$HourlyRateServiceItemImpl>
      get copyWith => __$$HourlyRateServiceItemImplCopyWithImpl<
          _$HourlyRateServiceItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)
        hourlyRateService,
    required TResult Function(int? serviceMonth, int? serviceYear,
            double fixedPrice, String serviceDescription)
        fixedPriceService,
  }) {
    return hourlyRateService(
        serviceMonth, serviceYear, hours, hourlyRate, serviceDescription);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)?
        hourlyRateService,
    TResult? Function(int? serviceMonth, int? serviceYear, double fixedPrice,
            String serviceDescription)?
        fixedPriceService,
  }) {
    return hourlyRateService?.call(
        serviceMonth, serviceYear, hours, hourlyRate, serviceDescription);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)?
        hourlyRateService,
    TResult Function(int? serviceMonth, int? serviceYear, double fixedPrice,
            String serviceDescription)?
        fixedPriceService,
    required TResult orElse(),
  }) {
    if (hourlyRateService != null) {
      return hourlyRateService(
          serviceMonth, serviceYear, hours, hourlyRate, serviceDescription);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_HourlyRateServiceItem value) hourlyRateService,
    required TResult Function(_FixedPriceServiceItem value) fixedPriceService,
  }) {
    return hourlyRateService(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_HourlyRateServiceItem value)? hourlyRateService,
    TResult? Function(_FixedPriceServiceItem value)? fixedPriceService,
  }) {
    return hourlyRateService?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HourlyRateServiceItem value)? hourlyRateService,
    TResult Function(_FixedPriceServiceItem value)? fixedPriceService,
    required TResult orElse(),
  }) {
    if (hourlyRateService != null) {
      return hourlyRateService(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HourlyRateServiceItemImplToJson(
      this,
    );
  }
}

abstract class _HourlyRateServiceItem extends InvoiceItem {
  const factory _HourlyRateServiceItem(
      {final int? serviceMonth,
      final int? serviceYear,
      required final double hours,
      required final double hourlyRate,
      required final String serviceDescription}) = _$HourlyRateServiceItemImpl;
  const _HourlyRateServiceItem._() : super._();

  factory _HourlyRateServiceItem.fromJson(Map<String, dynamic> json) =
      _$HourlyRateServiceItemImpl.fromJson;

  @override
  int? get serviceMonth;
  @override
  int? get serviceYear;
  double get hours;
  double get hourlyRate;
  @override
  String get serviceDescription;
  @override
  @JsonKey(ignore: true)
  _$$HourlyRateServiceItemImplCopyWith<_$HourlyRateServiceItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FixedPriceServiceItemImplCopyWith<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  factory _$$FixedPriceServiceItemImplCopyWith(
          _$FixedPriceServiceItemImpl value,
          $Res Function(_$FixedPriceServiceItemImpl) then) =
      __$$FixedPriceServiceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? serviceMonth,
      int? serviceYear,
      double fixedPrice,
      String serviceDescription});
}

/// @nodoc
class __$$FixedPriceServiceItemImplCopyWithImpl<$Res>
    extends _$InvoiceItemCopyWithImpl<$Res, _$FixedPriceServiceItemImpl>
    implements _$$FixedPriceServiceItemImplCopyWith<$Res> {
  __$$FixedPriceServiceItemImplCopyWithImpl(_$FixedPriceServiceItemImpl _value,
      $Res Function(_$FixedPriceServiceItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceMonth = freezed,
    Object? serviceYear = freezed,
    Object? fixedPrice = null,
    Object? serviceDescription = null,
  }) {
    return _then(_$FixedPriceServiceItemImpl(
      serviceMonth: freezed == serviceMonth
          ? _value.serviceMonth
          : serviceMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceYear: freezed == serviceYear
          ? _value.serviceYear
          : serviceYear // ignore: cast_nullable_to_non_nullable
              as int?,
      fixedPrice: null == fixedPrice
          ? _value.fixedPrice
          : fixedPrice // ignore: cast_nullable_to_non_nullable
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
class _$FixedPriceServiceItemImpl extends _FixedPriceServiceItem {
  const _$FixedPriceServiceItemImpl(
      {this.serviceMonth,
      this.serviceYear,
      required this.fixedPrice,
      required this.serviceDescription,
      final String? $type})
      : $type = $type ?? 'fixedPriceService',
        super._();

  factory _$FixedPriceServiceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedPriceServiceItemImplFromJson(json);

  @override
  final int? serviceMonth;
  @override
  final int? serviceYear;
  @override
  final double fixedPrice;
  @override
  final String serviceDescription;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'InvoiceItem.fixedPriceService(serviceMonth: $serviceMonth, serviceYear: $serviceYear, fixedPrice: $fixedPrice, serviceDescription: $serviceDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedPriceServiceItemImpl &&
            (identical(other.serviceMonth, serviceMonth) ||
                other.serviceMonth == serviceMonth) &&
            (identical(other.serviceYear, serviceYear) ||
                other.serviceYear == serviceYear) &&
            (identical(other.fixedPrice, fixedPrice) ||
                other.fixedPrice == fixedPrice) &&
            (identical(other.serviceDescription, serviceDescription) ||
                other.serviceDescription == serviceDescription));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, serviceMonth, serviceYear, fixedPrice, serviceDescription);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedPriceServiceItemImplCopyWith<_$FixedPriceServiceItemImpl>
      get copyWith => __$$FixedPriceServiceItemImplCopyWithImpl<
          _$FixedPriceServiceItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)
        hourlyRateService,
    required TResult Function(int? serviceMonth, int? serviceYear,
            double fixedPrice, String serviceDescription)
        fixedPriceService,
  }) {
    return fixedPriceService(
        serviceMonth, serviceYear, fixedPrice, serviceDescription);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)?
        hourlyRateService,
    TResult? Function(int? serviceMonth, int? serviceYear, double fixedPrice,
            String serviceDescription)?
        fixedPriceService,
  }) {
    return fixedPriceService?.call(
        serviceMonth, serviceYear, fixedPrice, serviceDescription);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? serviceMonth, int? serviceYear, double hours,
            double hourlyRate, String serviceDescription)?
        hourlyRateService,
    TResult Function(int? serviceMonth, int? serviceYear, double fixedPrice,
            String serviceDescription)?
        fixedPriceService,
    required TResult orElse(),
  }) {
    if (fixedPriceService != null) {
      return fixedPriceService(
          serviceMonth, serviceYear, fixedPrice, serviceDescription);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_HourlyRateServiceItem value) hourlyRateService,
    required TResult Function(_FixedPriceServiceItem value) fixedPriceService,
  }) {
    return fixedPriceService(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_HourlyRateServiceItem value)? hourlyRateService,
    TResult? Function(_FixedPriceServiceItem value)? fixedPriceService,
  }) {
    return fixedPriceService?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HourlyRateServiceItem value)? hourlyRateService,
    TResult Function(_FixedPriceServiceItem value)? fixedPriceService,
    required TResult orElse(),
  }) {
    if (fixedPriceService != null) {
      return fixedPriceService(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedPriceServiceItemImplToJson(
      this,
    );
  }
}

abstract class _FixedPriceServiceItem extends InvoiceItem {
  const factory _FixedPriceServiceItem(
      {final int? serviceMonth,
      final int? serviceYear,
      required final double fixedPrice,
      required final String serviceDescription}) = _$FixedPriceServiceItemImpl;
  const _FixedPriceServiceItem._() : super._();

  factory _FixedPriceServiceItem.fromJson(Map<String, dynamic> json) =
      _$FixedPriceServiceItemImpl.fromJson;

  @override
  int? get serviceMonth;
  @override
  int? get serviceYear;
  double get fixedPrice;
  @override
  String get serviceDescription;
  @override
  @JsonKey(ignore: true)
  _$$FixedPriceServiceItemImplCopyWith<_$FixedPriceServiceItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}
