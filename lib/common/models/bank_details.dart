import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_details.freezed.dart';
part 'bank_details.g.dart';

@freezed
class BankDetails with _$BankDetails {
  const factory BankDetails({
    required String accountHolder,
    required String institution,
    required String iban,
    required String bic,
  }) = _BankDetails;

  factory BankDetails.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsFromJson(json);
}
