import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_item.freezed.dart';
part 'invoice_item.g.dart';

enum UnitType {
  hours,
  minutes,
  amount,
}

@freezed
class InvoiceItem with _$InvoiceItem {
  const InvoiceItem._();

  const factory InvoiceItem({
    int? serviceMonth,
    int? serviceYear,
    DateTime? serviceDate,
    @Default(UnitType.hours) UnitType unitType,
    @Default(0.0) double quantity,
    @Default(0.0) double unitPrice,
    required String serviceDescription,
  }) = _InvoiceItem;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => _$InvoiceItemFromJson(json);

  /// Any service period set (month+year range OR a single date).
  bool get hasServicePeriod => serviceDate != null || (serviceMonth != null && serviceYear != null);

  double get itemTotal => quantity * unitPrice;

  String get unitLabel {
    switch (unitType) {
      case UnitType.hours:
        return 'Std.';
      case UnitType.minutes:
        return 'Min.';
      case UnitType.amount:
        return 'Stk.';
    }
  }
}
