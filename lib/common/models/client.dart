import 'package:freezed_annotation/freezed_annotation.dart';

part 'client.freezed.dart';
part 'client.g.dart';

@freezed
class Client with _$Client {
  const Client._();

  const factory Client({
    @Default('') String name,
    @Default('') String address,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) =>
      _$ClientFromJson(json);

  /// Multiline string for PDF (name then address).
  String toBlockString() {
    final n = name.trim();
    final a = address.trim();
    if (n.isEmpty) return a;
    if (a.isEmpty) return n;
    return '$n\n$a';
  }
}
