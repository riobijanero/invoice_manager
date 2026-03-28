// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_defaults.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvoiceDefaults _$InvoiceDefaultsFromJson(Map<String, dynamic> json) {
  return _InvoiceDefaults.fromJson(json);
}

/// @nodoc
mixin _$InvoiceDefaults {
  String get lastInvoiceNumber => throw _privateConstructorUsedError;
  Sender get sender => throw _privateConstructorUsedError;
  Client get client => throw _privateConstructorUsedError;
  String get contractNumber => throw _privateConstructorUsedError;
  BankDetails? get bankDetails => throw _privateConstructorUsedError;
  String get ustId => throw _privateConstructorUsedError;
  String get businessTitle => throw _privateConstructorUsedError;
  double get hourlyRate => throw _privateConstructorUsedError;
  DiscountType get discountType => throw _privateConstructorUsedError;
  double get discountValue => throw _privateConstructorUsedError;
  DueDateType get dueDateType => throw _privateConstructorUsedError;
  String get serviceDescriptionTemplate => throw _privateConstructorUsedError;
  List<SavedServicePreset> get savedServicePresets =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InvoiceDefaultsCopyWith<InvoiceDefaults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceDefaultsCopyWith<$Res> {
  factory $InvoiceDefaultsCopyWith(
          InvoiceDefaults value, $Res Function(InvoiceDefaults) then) =
      _$InvoiceDefaultsCopyWithImpl<$Res, InvoiceDefaults>;
  @useResult
  $Res call(
      {String lastInvoiceNumber,
      Sender sender,
      Client client,
      String contractNumber,
      BankDetails? bankDetails,
      String ustId,
      String businessTitle,
      double hourlyRate,
      DiscountType discountType,
      double discountValue,
      DueDateType dueDateType,
      String serviceDescriptionTemplate,
      List<SavedServicePreset> savedServicePresets});

  $SenderCopyWith<$Res> get sender;
  $ClientCopyWith<$Res> get client;
  $BankDetailsCopyWith<$Res>? get bankDetails;
}

/// @nodoc
class _$InvoiceDefaultsCopyWithImpl<$Res, $Val extends InvoiceDefaults>
    implements $InvoiceDefaultsCopyWith<$Res> {
  _$InvoiceDefaultsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastInvoiceNumber = null,
    Object? sender = null,
    Object? client = null,
    Object? contractNumber = null,
    Object? bankDetails = freezed,
    Object? ustId = null,
    Object? businessTitle = null,
    Object? hourlyRate = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? dueDateType = null,
    Object? serviceDescriptionTemplate = null,
    Object? savedServicePresets = null,
  }) {
    return _then(_value.copyWith(
      lastInvoiceNumber: null == lastInvoiceNumber
          ? _value.lastInvoiceNumber
          : lastInvoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as Sender,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as Client,
      contractNumber: null == contractNumber
          ? _value.contractNumber
          : contractNumber // ignore: cast_nullable_to_non_nullable
              as String,
      bankDetails: freezed == bankDetails
          ? _value.bankDetails
          : bankDetails // ignore: cast_nullable_to_non_nullable
              as BankDetails?,
      ustId: null == ustId
          ? _value.ustId
          : ustId // ignore: cast_nullable_to_non_nullable
              as String,
      businessTitle: null == businessTitle
          ? _value.businessTitle
          : businessTitle // ignore: cast_nullable_to_non_nullable
              as String,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as DiscountType,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      dueDateType: null == dueDateType
          ? _value.dueDateType
          : dueDateType // ignore: cast_nullable_to_non_nullable
              as DueDateType,
      serviceDescriptionTemplate: null == serviceDescriptionTemplate
          ? _value.serviceDescriptionTemplate
          : serviceDescriptionTemplate // ignore: cast_nullable_to_non_nullable
              as String,
      savedServicePresets: null == savedServicePresets
          ? _value.savedServicePresets
          : savedServicePresets // ignore: cast_nullable_to_non_nullable
              as List<SavedServicePreset>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SenderCopyWith<$Res> get sender {
    return $SenderCopyWith<$Res>(_value.sender, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ClientCopyWith<$Res> get client {
    return $ClientCopyWith<$Res>(_value.client, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BankDetailsCopyWith<$Res>? get bankDetails {
    if (_value.bankDetails == null) {
      return null;
    }

    return $BankDetailsCopyWith<$Res>(_value.bankDetails!, (value) {
      return _then(_value.copyWith(bankDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InvoiceDefaultsImplCopyWith<$Res>
    implements $InvoiceDefaultsCopyWith<$Res> {
  factory _$$InvoiceDefaultsImplCopyWith(_$InvoiceDefaultsImpl value,
          $Res Function(_$InvoiceDefaultsImpl) then) =
      __$$InvoiceDefaultsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String lastInvoiceNumber,
      Sender sender,
      Client client,
      String contractNumber,
      BankDetails? bankDetails,
      String ustId,
      String businessTitle,
      double hourlyRate,
      DiscountType discountType,
      double discountValue,
      DueDateType dueDateType,
      String serviceDescriptionTemplate,
      List<SavedServicePreset> savedServicePresets});

  @override
  $SenderCopyWith<$Res> get sender;
  @override
  $ClientCopyWith<$Res> get client;
  @override
  $BankDetailsCopyWith<$Res>? get bankDetails;
}

/// @nodoc
class __$$InvoiceDefaultsImplCopyWithImpl<$Res>
    extends _$InvoiceDefaultsCopyWithImpl<$Res, _$InvoiceDefaultsImpl>
    implements _$$InvoiceDefaultsImplCopyWith<$Res> {
  __$$InvoiceDefaultsImplCopyWithImpl(
      _$InvoiceDefaultsImpl _value, $Res Function(_$InvoiceDefaultsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastInvoiceNumber = null,
    Object? sender = null,
    Object? client = null,
    Object? contractNumber = null,
    Object? bankDetails = freezed,
    Object? ustId = null,
    Object? businessTitle = null,
    Object? hourlyRate = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? dueDateType = null,
    Object? serviceDescriptionTemplate = null,
    Object? savedServicePresets = null,
  }) {
    return _then(_$InvoiceDefaultsImpl(
      lastInvoiceNumber: null == lastInvoiceNumber
          ? _value.lastInvoiceNumber
          : lastInvoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as Sender,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as Client,
      contractNumber: null == contractNumber
          ? _value.contractNumber
          : contractNumber // ignore: cast_nullable_to_non_nullable
              as String,
      bankDetails: freezed == bankDetails
          ? _value.bankDetails
          : bankDetails // ignore: cast_nullable_to_non_nullable
              as BankDetails?,
      ustId: null == ustId
          ? _value.ustId
          : ustId // ignore: cast_nullable_to_non_nullable
              as String,
      businessTitle: null == businessTitle
          ? _value.businessTitle
          : businessTitle // ignore: cast_nullable_to_non_nullable
              as String,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as DiscountType,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      dueDateType: null == dueDateType
          ? _value.dueDateType
          : dueDateType // ignore: cast_nullable_to_non_nullable
              as DueDateType,
      serviceDescriptionTemplate: null == serviceDescriptionTemplate
          ? _value.serviceDescriptionTemplate
          : serviceDescriptionTemplate // ignore: cast_nullable_to_non_nullable
              as String,
      savedServicePresets: null == savedServicePresets
          ? _value._savedServicePresets
          : savedServicePresets // ignore: cast_nullable_to_non_nullable
              as List<SavedServicePreset>,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$InvoiceDefaultsImpl extends _InvoiceDefaults {
  const _$InvoiceDefaultsImpl(
      {this.lastInvoiceNumber = '',
      this.sender = const Sender(),
      this.client = const Client(),
      this.contractNumber = '',
      this.bankDetails,
      this.ustId = '',
      this.businessTitle = 'App und Webentwicklung',
      this.hourlyRate = 0.0,
      this.discountType = DiscountType.percent,
      this.discountValue = 0.0,
      this.dueDateType = DueDateType.twoWeeks,
      this.serviceDescriptionTemplate = '',
      final List<SavedServicePreset> savedServicePresets =
          const <SavedServicePreset>[]})
      : _savedServicePresets = savedServicePresets,
        super._();

  factory _$InvoiceDefaultsImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceDefaultsImplFromJson(json);

  @override
  @JsonKey()
  final String lastInvoiceNumber;
  @override
  @JsonKey()
  final Sender sender;
  @override
  @JsonKey()
  final Client client;
  @override
  @JsonKey()
  final String contractNumber;
  @override
  final BankDetails? bankDetails;
  @override
  @JsonKey()
  final String ustId;
  @override
  @JsonKey()
  final String businessTitle;
  @override
  @JsonKey()
  final double hourlyRate;
  @override
  @JsonKey()
  final DiscountType discountType;
  @override
  @JsonKey()
  final double discountValue;
  @override
  @JsonKey()
  final DueDateType dueDateType;
  @override
  @JsonKey()
  final String serviceDescriptionTemplate;
  final List<SavedServicePreset> _savedServicePresets;
  @override
  @JsonKey()
  List<SavedServicePreset> get savedServicePresets {
    if (_savedServicePresets is EqualUnmodifiableListView)
      return _savedServicePresets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_savedServicePresets);
  }

  @override
  String toString() {
    return 'InvoiceDefaults(lastInvoiceNumber: $lastInvoiceNumber, sender: $sender, client: $client, contractNumber: $contractNumber, bankDetails: $bankDetails, ustId: $ustId, businessTitle: $businessTitle, hourlyRate: $hourlyRate, discountType: $discountType, discountValue: $discountValue, dueDateType: $dueDateType, serviceDescriptionTemplate: $serviceDescriptionTemplate, savedServicePresets: $savedServicePresets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceDefaultsImpl &&
            (identical(other.lastInvoiceNumber, lastInvoiceNumber) ||
                other.lastInvoiceNumber == lastInvoiceNumber) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.contractNumber, contractNumber) ||
                other.contractNumber == contractNumber) &&
            (identical(other.bankDetails, bankDetails) ||
                other.bankDetails == bankDetails) &&
            (identical(other.ustId, ustId) || other.ustId == ustId) &&
            (identical(other.businessTitle, businessTitle) ||
                other.businessTitle == businessTitle) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.dueDateType, dueDateType) ||
                other.dueDateType == dueDateType) &&
            (identical(other.serviceDescriptionTemplate,
                    serviceDescriptionTemplate) ||
                other.serviceDescriptionTemplate ==
                    serviceDescriptionTemplate) &&
            const DeepCollectionEquality()
                .equals(other._savedServicePresets, _savedServicePresets));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lastInvoiceNumber,
      sender,
      client,
      contractNumber,
      bankDetails,
      ustId,
      businessTitle,
      hourlyRate,
      discountType,
      discountValue,
      dueDateType,
      serviceDescriptionTemplate,
      const DeepCollectionEquality().hash(_savedServicePresets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceDefaultsImplCopyWith<_$InvoiceDefaultsImpl> get copyWith =>
      __$$InvoiceDefaultsImplCopyWithImpl<_$InvoiceDefaultsImpl>(
          this, _$identity);
}

abstract class _InvoiceDefaults extends InvoiceDefaults {
  const factory _InvoiceDefaults(
          {final String lastInvoiceNumber,
          final Sender sender,
          final Client client,
          final String contractNumber,
          final BankDetails? bankDetails,
          final String ustId,
          final String businessTitle,
          final double hourlyRate,
          final DiscountType discountType,
          final double discountValue,
          final DueDateType dueDateType,
          final String serviceDescriptionTemplate,
          final List<SavedServicePreset> savedServicePresets}) =
      _$InvoiceDefaultsImpl;
  const _InvoiceDefaults._() : super._();

  factory _InvoiceDefaults.fromJson(Map<String, dynamic> json) =
      _$InvoiceDefaultsImpl.fromJson;

  @override
  String get lastInvoiceNumber;
  @override
  Sender get sender;
  @override
  Client get client;
  @override
  String get contractNumber;
  @override
  BankDetails? get bankDetails;
  @override
  String get ustId;
  @override
  String get businessTitle;
  @override
  double get hourlyRate;
  @override
  DiscountType get discountType;
  @override
  double get discountValue;
  @override
  DueDateType get dueDateType;
  @override
  String get serviceDescriptionTemplate;
  @override
  List<SavedServicePreset> get savedServicePresets;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceDefaultsImplCopyWith<_$InvoiceDefaultsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
