import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';

part 'saved_service_preset.freezed.dart';
part 'saved_service_preset.g.dart';

/// User-saved line template: [description], [unitPrice], and [unitType] (Einheit).
@freezed
class SavedServicePreset with _$SavedServicePreset {
  const factory SavedServicePreset({
    @Default('') String description,
    @Default(0.0) double unitPrice,
    @Default(UnitType.hours) UnitType unitType,
  }) = _SavedServicePreset;

  factory SavedServicePreset.fromJson(Map<String, dynamic> json) =>
      _$SavedServicePresetFromJson(json);
}
