import 'package:freezed_annotation/freezed_annotation.dart';

import 'adress.dart';

part 'sender.freezed.dart';
part 'sender.g.dart';

@freezed
class Sender with _$Sender {
  const Sender._();

  const factory Sender({
    @Default('') String name,
    @Default('') String jobDescription,
    @Default(Adress()) Adress address,
    @Default('') String phoneNumber,
    @Default('') String email,
    @Default('') String website,
    @Default('') String ustId,
    @Default('') String taxNumber,
  }) = _Sender;

  factory Sender.fromJson(Map<String, dynamic> json) =>
      _$SenderFromJson(json);

  /// Multiline string for PDF header block (name, address, phone, email, website).
  String toBlockString() {
    final street = address.streetNameAndNumber.trim();
    final postal = address.postalCode != 0 ? address.postalCode.toString() : '';
    final town = address.town.trim();
    final postalTown = [postal, town].where((v) => v.isNotEmpty).join(' ');
    final country = address.country.trim();
    final parts = <String>[
      name.trim(),
      jobDescription.trim(),
    ];
    if (street.isNotEmpty) parts.add(street);
    if (postalTown.isNotEmpty) parts.add(postalTown);
    if (country.isNotEmpty && country.toLowerCase() != 'deutschland') parts.add(country);
    if (phoneNumber.trim().isNotEmpty) parts.add('Tel: ${phoneNumber.trim()}');
    if (email.trim().isNotEmpty) parts.add(email.trim());
    if (website.trim().isNotEmpty) parts.add(website.trim());
    return parts.where((s) => s.isNotEmpty).join('\n');
  }

  /// One-line summary (e.g. "Name | Street | City") for line above client.
  String toOneLine() {
    final street = address.streetNameAndNumber.trim();
    if (street.isEmpty) return name.trim();
    return '${name.trim()} | $street';
  }
}
