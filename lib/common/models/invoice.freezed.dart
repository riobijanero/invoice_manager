// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return _Invoice.fromJson(json);
}

/// @nodoc
mixin _$Invoice {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get invoiceNumber =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(toJson: _senderToJson)
  Sender get sender =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(toJson: _clientToJson)
  Client get client => throw _privateConstructorUsedError;
  String get contractNumber => throw _privateConstructorUsedError;
  BankDetails get bankDetails => throw _privateConstructorUsedError;
  DateTime get invoiceDate => throw _privateConstructorUsedError;
  List<InvoiceItem> get invoiceItemList => throw _privateConstructorUsedError;
  DiscountType get discountType => throw _privateConstructorUsedError;
  double get discountValue => throw _privateConstructorUsedError;
  double get vat => throw _privateConstructorUsedError;
  DueDateType get dueDateType => throw _privateConstructorUsedError;
  DateTime? get customDueDate => throw _privateConstructorUsedError;
  DateTime? get paidOn => throw _privateConstructorUsedError;
  String get introductoryText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String invoiceNumber,
      @JsonKey(toJson: _senderToJson) Sender sender,
      @JsonKey(toJson: _clientToJson) Client client,
      String contractNumber,
      BankDetails bankDetails,
      DateTime invoiceDate,
      List<InvoiceItem> invoiceItemList,
      DiscountType discountType,
      double discountValue,
      double vat,
      DueDateType dueDateType,
      DateTime? customDueDate,
      DateTime? paidOn,
      String introductoryText});

  $SenderCopyWith<$Res> get sender;
  $ClientCopyWith<$Res> get client;
  $BankDetailsCopyWith<$Res> get bankDetails;
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? invoiceNumber = null,
    Object? sender = null,
    Object? client = null,
    Object? contractNumber = null,
    Object? bankDetails = null,
    Object? invoiceDate = null,
    Object? invoiceItemList = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? vat = null,
    Object? dueDateType = null,
    Object? customDueDate = freezed,
    Object? paidOn = freezed,
    Object? introductoryText = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
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
      bankDetails: null == bankDetails
          ? _value.bankDetails
          : bankDetails // ignore: cast_nullable_to_non_nullable
              as BankDetails,
      invoiceDate: null == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      invoiceItemList: null == invoiceItemList
          ? _value.invoiceItemList
          : invoiceItemList // ignore: cast_nullable_to_non_nullable
              as List<InvoiceItem>,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as DiscountType,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      vat: null == vat
          ? _value.vat
          : vat // ignore: cast_nullable_to_non_nullable
              as double,
      dueDateType: null == dueDateType
          ? _value.dueDateType
          : dueDateType // ignore: cast_nullable_to_non_nullable
              as DueDateType,
      customDueDate: freezed == customDueDate
          ? _value.customDueDate
          : customDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidOn: freezed == paidOn
          ? _value.paidOn
          : paidOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      introductoryText: null == introductoryText
          ? _value.introductoryText
          : introductoryText // ignore: cast_nullable_to_non_nullable
              as String,
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
  $BankDetailsCopyWith<$Res> get bankDetails {
    return $BankDetailsCopyWith<$Res>(_value.bankDetails, (value) {
      return _then(_value.copyWith(bankDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
          _$InvoiceImpl value, $Res Function(_$InvoiceImpl) then) =
      __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String invoiceNumber,
      @JsonKey(toJson: _senderToJson) Sender sender,
      @JsonKey(toJson: _clientToJson) Client client,
      String contractNumber,
      BankDetails bankDetails,
      DateTime invoiceDate,
      List<InvoiceItem> invoiceItemList,
      DiscountType discountType,
      double discountValue,
      double vat,
      DueDateType dueDateType,
      DateTime? customDueDate,
      DateTime? paidOn,
      String introductoryText});

  @override
  $SenderCopyWith<$Res> get sender;
  @override
  $ClientCopyWith<$Res> get client;
  @override
  $BankDetailsCopyWith<$Res> get bankDetails;
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
      _$InvoiceImpl _value, $Res Function(_$InvoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? invoiceNumber = null,
    Object? sender = null,
    Object? client = null,
    Object? contractNumber = null,
    Object? bankDetails = null,
    Object? invoiceDate = null,
    Object? invoiceItemList = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? vat = null,
    Object? dueDateType = null,
    Object? customDueDate = freezed,
    Object? paidOn = freezed,
    Object? introductoryText = null,
  }) {
    return _then(_$InvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
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
      bankDetails: null == bankDetails
          ? _value.bankDetails
          : bankDetails // ignore: cast_nullable_to_non_nullable
              as BankDetails,
      invoiceDate: null == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      invoiceItemList: null == invoiceItemList
          ? _value._invoiceItemList
          : invoiceItemList // ignore: cast_nullable_to_non_nullable
              as List<InvoiceItem>,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as DiscountType,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      vat: null == vat
          ? _value.vat
          : vat // ignore: cast_nullable_to_non_nullable
              as double,
      dueDateType: null == dueDateType
          ? _value.dueDateType
          : dueDateType // ignore: cast_nullable_to_non_nullable
              as DueDateType,
      customDueDate: freezed == customDueDate
          ? _value.customDueDate
          : customDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidOn: freezed == paidOn
          ? _value.paidOn
          : paidOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      introductoryText: null == introductoryText
          ? _value.introductoryText
          : introductoryText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceImpl implements _Invoice {
  const _$InvoiceImpl(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.invoiceNumber,
      @JsonKey(toJson: _senderToJson) required this.sender,
      @JsonKey(toJson: _clientToJson) required this.client,
      this.contractNumber = '',
      required this.bankDetails,
      required this.invoiceDate,
      final List<InvoiceItem> invoiceItemList = const <InvoiceItem>[],
      this.discountType = DiscountType.percent,
      this.discountValue = 0.0,
      this.vat = 0.19,
      this.dueDateType = DueDateType.twoWeeks,
      this.customDueDate,
      this.paidOn,
      this.introductoryText =
          'Sehr geehrte Damen und Herren,\nfür das Erbringen meiner Dienstleistungen berechne ich Ihnen:'})
      : _invoiceItemList = invoiceItemList;

  factory _$InvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String invoiceNumber;
// ignore: invalid_annotation_target
  @override
  @JsonKey(toJson: _senderToJson)
  final Sender sender;
// ignore: invalid_annotation_target
  @override
  @JsonKey(toJson: _clientToJson)
  final Client client;
  @override
  @JsonKey()
  final String contractNumber;
  @override
  final BankDetails bankDetails;
  @override
  final DateTime invoiceDate;
  final List<InvoiceItem> _invoiceItemList;
  @override
  @JsonKey()
  List<InvoiceItem> get invoiceItemList {
    if (_invoiceItemList is EqualUnmodifiableListView) return _invoiceItemList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoiceItemList);
  }

  @override
  @JsonKey()
  final DiscountType discountType;
  @override
  @JsonKey()
  final double discountValue;
  @override
  @JsonKey()
  final double vat;
  @override
  @JsonKey()
  final DueDateType dueDateType;
  @override
  final DateTime? customDueDate;
  @override
  final DateTime? paidOn;
  @override
  @JsonKey()
  final String introductoryText;

  @override
  String toString() {
    return 'Invoice(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, invoiceNumber: $invoiceNumber, sender: $sender, client: $client, contractNumber: $contractNumber, bankDetails: $bankDetails, invoiceDate: $invoiceDate, invoiceItemList: $invoiceItemList, discountType: $discountType, discountValue: $discountValue, vat: $vat, dueDateType: $dueDateType, customDueDate: $customDueDate, paidOn: $paidOn, introductoryText: $introductoryText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.contractNumber, contractNumber) ||
                other.contractNumber == contractNumber) &&
            (identical(other.bankDetails, bankDetails) ||
                other.bankDetails == bankDetails) &&
            (identical(other.invoiceDate, invoiceDate) ||
                other.invoiceDate == invoiceDate) &&
            const DeepCollectionEquality()
                .equals(other._invoiceItemList, _invoiceItemList) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.vat, vat) || other.vat == vat) &&
            (identical(other.dueDateType, dueDateType) ||
                other.dueDateType == dueDateType) &&
            (identical(other.customDueDate, customDueDate) ||
                other.customDueDate == customDueDate) &&
            (identical(other.paidOn, paidOn) || other.paidOn == paidOn) &&
            (identical(other.introductoryText, introductoryText) ||
                other.introductoryText == introductoryText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      invoiceNumber,
      sender,
      client,
      contractNumber,
      bankDetails,
      invoiceDate,
      const DeepCollectionEquality().hash(_invoiceItemList),
      discountType,
      discountValue,
      vat,
      dueDateType,
      customDueDate,
      paidOn,
      introductoryText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceImplToJson(
      this,
    );
  }
}

abstract class _Invoice implements Invoice {
  const factory _Invoice(
      {required final String id,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final String invoiceNumber,
      @JsonKey(toJson: _senderToJson) required final Sender sender,
      @JsonKey(toJson: _clientToJson) required final Client client,
      final String contractNumber,
      required final BankDetails bankDetails,
      required final DateTime invoiceDate,
      final List<InvoiceItem> invoiceItemList,
      final DiscountType discountType,
      final double discountValue,
      final double vat,
      final DueDateType dueDateType,
      final DateTime? customDueDate,
      final DateTime? paidOn,
      final String introductoryText}) = _$InvoiceImpl;

  factory _Invoice.fromJson(Map<String, dynamic> json) = _$InvoiceImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get invoiceNumber;
  @override // ignore: invalid_annotation_target
  @JsonKey(toJson: _senderToJson)
  Sender get sender;
  @override // ignore: invalid_annotation_target
  @JsonKey(toJson: _clientToJson)
  Client get client;
  @override
  String get contractNumber;
  @override
  BankDetails get bankDetails;
  @override
  DateTime get invoiceDate;
  @override
  List<InvoiceItem> get invoiceItemList;
  @override
  DiscountType get discountType;
  @override
  double get discountValue;
  @override
  double get vat;
  @override
  DueDateType get dueDateType;
  @override
  DateTime? get customDueDate;
  @override
  DateTime? get paidOn;
  @override
  String get introductoryText;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
