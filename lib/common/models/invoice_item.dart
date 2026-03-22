import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_item.freezed.dart';
part 'invoice_item.g.dart';

enum InvoiceItemType {
  hourlyRateService,
  fixedPriceService,
}

@freezed
class InvoiceItem with _$InvoiceItem {
  const InvoiceItem._();

  const factory InvoiceItem.hourlyRateService({
    int? serviceMonth,
    int? serviceYear,
    required double hours,
    required double hourlyRate,
    required String serviceDescription,
  }) = _HourlyRateServiceItem;

  const factory InvoiceItem.fixedPriceService({
    int? serviceMonth,
    int? serviceYear,
    required double fixedPrice,
    required String serviceDescription,
  }) = _FixedPriceServiceItem;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);

  /// Both month and year set → line appears on the PDF and counts toward totals.
  bool get hasServicePeriod => serviceMonth != null && serviceYear != null;

  // Common accessors so the rest of the app can stay readable.
  int? get serviceMonth => map(
        hourlyRateService: (v) => v.serviceMonth,
        fixedPriceService: (v) => v.serviceMonth,
      );

  int? get serviceYear => map(
        hourlyRateService: (v) => v.serviceYear,
        fixedPriceService: (v) => v.serviceYear,
      );

  String get serviceDescription => map(
        hourlyRateService: (v) => v.serviceDescription,
        fixedPriceService: (v) => v.serviceDescription,
      );

  double get itemTotal => map(
        hourlyRateService: (v) => v.hours * v.hourlyRate,
        fixedPriceService: (v) => v.fixedPrice,
      );

  // Table helpers.
  String get unitLabel => map(
        hourlyRateService: (_) => 'Std.',
        fixedPriceService: (_) => 'Pausch.',
      );

  double get quantity => map(
        hourlyRateService: (v) => v.hours,
        fixedPriceService: (_) => 1,
      );

  double get unitPrice => map(
        hourlyRateService: (v) => v.hourlyRate,
        fixedPriceService: (v) => v.fixedPrice,
      );

  InvoiceItemType get type => map(
        hourlyRateService: (_) => InvoiceItemType.hourlyRateService,
        fixedPriceService: (_) => InvoiceItemType.fixedPriceService,
      );

  double get hours => map(
        hourlyRateService: (v) => v.hours,
        fixedPriceService: (_) => 0,
      );

  double get hourlyRate => map(
        hourlyRateService: (v) => v.hourlyRate,
        fixedPriceService: (_) => 0,
      );

  double get fixedPrice => map(
        hourlyRateService: (_) => 0,
        fixedPriceService: (v) => v.fixedPrice,
      );
}

