import 'package:freezed_annotation/freezed_annotation.dart';

import 'adress.dart';

part 'client.freezed.dart';
part 'client.g.dart';

@freezed
class Client with _$Client {
  const Client._();

  const factory Client({
    @Default('') String clientId,
    @Default('') String companyName,
    @Default('') String name,
    @Default(Adress()) Adress address,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) =>
      _$ClientFromJson(json);

  /// Multiline string for PDF (name then address).
  String toBlockString() {
    final c = companyName.trim();
    final n = name.trim();
    final street = address.streetNameAndNumber.trim();
    final postal = address.postalCode != 0 ? address.postalCode.toString() : '';
    final town = address.town.trim();
    final postalTown = [postal, town].where((v) => v.isNotEmpty).join(' ');
    final country = address.country.trim();
    final lines = <String>[];
    if (c.isNotEmpty) lines.add(c);
    if (n.isNotEmpty) lines.add(n);
    if (street.isNotEmpty) lines.add(street);
    if (postalTown.isNotEmpty) lines.add(postalTown);
    if (country.isNotEmpty && country.toLowerCase() != 'deutschland') lines.add(country);
    return lines.join('\n');
  }
}
