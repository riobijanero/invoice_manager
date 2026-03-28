import 'package:freezed_annotation/freezed_annotation.dart';

import 'bank_details.dart';
import 'client.dart';
import 'discount_type.dart';
import 'due_date_type.dart';
import 'saved_service_preset.dart';
import 'sender.dart';

part 'invoice_defaults.freezed.dart';
part 'invoice_defaults.g.dart';

/// App-wide defaults that remember the last used values when creating invoices.
///
/// These values are:
/// - Loaded when the invoice form opens to prefill sender, client, bank data, etc.
/// - Updated when an invoice is saved for sender, bank, rates, etc.; **Kunde** and
///   **Vertragsnummer** only when the user taps „Kundendaten speichern“.
/// - [savedServicePresets] stores Leistungsbeschreibung + Einzelpreis + Einheit
///   for quick reuse (user adds via „Vorlage speichern“ in the form).
///
/// This makes repeated invoice creation much faster and keeps things consistent
/// (same business title, same USt-ID, same hourly rate and due date, etc.).
@Freezed(toJson: false)
class InvoiceDefaults with _$InvoiceDefaults {
  const InvoiceDefaults._();
  const factory InvoiceDefaults({
    @Default('') String lastInvoiceNumber,
    @Default(Sender()) Sender sender,
    @Default(Client()) Client client,
    @Default('') String contractNumber,
    BankDetails? bankDetails,
    @Default('') String ustId,
    @Default('App und Webentwicklung') String businessTitle,
    @Default(0.0) double hourlyRate,
    @Default(DiscountType.percent) DiscountType discountType,
    @Default(0.0) double discountValue,
    @Default(DueDateType.twoWeeks) DueDateType dueDateType,
    @Default('') String serviceDescriptionTemplate,
    @Default(<SavedServicePreset>[]) List<SavedServicePreset> savedServicePresets,
  }) = _InvoiceDefaults;

  factory InvoiceDefaults.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDefaultsFromJson(json);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lastInvoiceNumber': lastInvoiceNumber,
        'sender': sender.toJson(),
        'client': client.toJson(),
        'contractNumber': contractNumber,
        'bankDetails': bankDetails?.toJson(),
        'ustId': ustId,
        'businessTitle': businessTitle,
        'hourlyRate': hourlyRate,
        'discountType': discountType.name,
        'discountValue': discountValue,
        'dueDateType': dueDateType.name,
        'serviceDescriptionTemplate': serviceDescriptionTemplate,
        'savedServicePresets':
            savedServicePresets.map((e) => e.toJson()).toList(),
      };
}

/// Default service description with {PERIOD} placeholder (dd.MM.yyyy - dd.MM.yyyy).
const String defaultServiceDescriptionTemplate = 'Entwicklung einer App für Web und mobile in Flutter\n'
    'Leistungszeitraum: {PERIOD}\n'
    '(Für Details, siehe Stundenübersicht im Anhang)';
