import 'package:freezed_annotation/freezed_annotation.dart';

import 'bank_details.dart';
import 'client.dart';
import 'discount_type.dart';
import 'due_date_type.dart';
import 'sender.dart';

part 'app_defaults.freezed.dart';
part 'app_defaults.g.dart';

/// Last-used values for creating new invoices. Persisted locally.
@Freezed(toJson: false)
class AppDefaults with _$AppDefaults {
  const AppDefaults._();
  const factory AppDefaults({
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
  }) = _AppDefaults;

  factory AppDefaults.fromJson(Map<String, dynamic> json) =>
      _$AppDefaultsFromJson(_migrateDefaultsJson(json));

  /// Supports legacy JSON with senderAddress/clientAddress strings.
  static Map<String, dynamic> _migrateDefaultsJson(Map<String, dynamic> json) {
    final out = Map<String, dynamic>.from(json);
    if (out['sender'] == null && out['senderAddress'] != null) {
      out['sender'] = _senderFromLegacyString(out['senderAddress'] as String? ?? '');
    }
    if (out['client'] == null && out['clientAddress'] != null) {
      out['client'] = _clientFromLegacyString(out['clientAddress'] as String? ?? '');
    }
    return out;
  }

  static Map<String, dynamic> _senderFromLegacyString(String s) {
    final lines = s.split(RegExp(r'[\r\n]+'));
    if (lines.isEmpty) return const Sender().toJson();
    return Sender(
      name: lines.first.trim(),
      address: lines.skip(1).join('\n').trim(),
    ).toJson();
  }

  static Map<String, dynamic> _clientFromLegacyString(String s) {
    final lines = s.split(RegExp(r'[\r\n]+'));
    if (lines.isEmpty) return const Client().toJson();
    return Client(
      name: lines.first.trim(),
      address: lines.skip(1).join('\n').trim(),
    ).toJson();
  }

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
      };
}

/// Default service description with {PERIOD} placeholder (dd.MM.yyyy - dd.MM.yyyy).
const String defaultServiceDescriptionTemplate =
    'Entwicklung einer App für Web und mobile in Flutter\n'
    'Leistungszeitraum: {PERIOD}\n'
    '(Für Details, siehe Stundenübersicht im Anhang)';
