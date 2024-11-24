import 'package:freezed_annotation/freezed_annotation.dart';
part 'business_model.freezed.dart';
part 'business_model.g.dart';

@freezed
class BusinessModel with _$BusinessModel {
  const factory BusinessModel({
    required String name,
  }) = _BusinessModel;

  factory BusinessModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessModelFromJson(json);
}
