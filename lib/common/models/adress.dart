import 'package:freezed_annotation/freezed_annotation.dart';

part 'adress.freezed.dart';
part 'adress.g.dart';

@freezed
class Adress with _$Adress {
  const Adress._();

  const factory Adress({
    @Default('') String streetNameAndNumber,
    @Default('') String town,
    @Default('') String country,
    @Default(0) int postalCode,
  }) = _Adress;

  factory Adress.fromJson(Map<String, dynamic> json) => _$AdressFromJson(json);
}

