import 'package:freezed_annotation/freezed_annotation.dart';

part 'sender.freezed.dart';
part 'sender.g.dart';

@freezed
class Sender with _$Sender {
  const Sender._();

  const factory Sender({
    @Default('') String name,
    @Default('') String jobDescription,
    @Default('') String address,
    @Default('') String phoneNumber,
    @Default('') String email,
    @Default('') String website,
    @Default('') String ustId,
  }) = _Sender;

  factory Sender.fromJson(Map<String, dynamic> json) =>
      _$SenderFromJson(json);

  /// Multiline string for PDF header block (name, address, phone, email, website).
  String toBlockString() {
    final parts = <String>[
      name.trim(),
      jobDescription.trim(),
      address.trim(),
    ];
    if (phoneNumber.trim().isNotEmpty) parts.add('Tel: ${phoneNumber.trim()}');
    if (email.trim().isNotEmpty) parts.add(email.trim());
    if (website.trim().isNotEmpty) parts.add(website.trim());
    return parts.where((s) => s.isNotEmpty).join('\n');
  }

  /// One-line summary (e.g. "Name | Street | City") for line above client.
  String toOneLine() {
    final lines = address.split(RegExp(r'[\r\n]+'));
    final firstAddressLine = lines.isEmpty ? '' : lines.first.trim();
    if (firstAddressLine.isEmpty) return name.trim();
    return '${name.trim()} | $firstAddressLine';
  }
}
