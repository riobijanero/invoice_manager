import 'package:freezed_annotation/freezed_annotation.dart';

part 'client.freezed.dart';
part 'client.g.dart';

@freezed
class Client with _$Client {
  const Client._();

  const factory Client({
    @Default('') String companyName,
    @Default('') String name,
    @Default('') String address,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) =>
      _$ClientFromJson(json);

  /// Multiline string for PDF (name then address).
  String toBlockString() {
    final c = companyName.trim();
    final n = name.trim();
    final a = address.trim();
    final lines = <String>[];
    if (c.isNotEmpty) lines.add(c);
    if (n.isNotEmpty) lines.add(n);
    if (a.isNotEmpty) lines.addAll(a.split('\n').where((l) => l.trim().isNotEmpty));
    return lines.join('\n');
  }
}
