import 'package:freezed_annotation/freezed_annotation.dart';
part 'services_model.freezed.dart';
part 'services_model.g.dart';

@freezed
class ServicesModel with _$ServicesModel {
  const factory ServicesModel({
    required String name,
    required String category,
    required String description,
    required double price,
    required int duration,
  }) = _ServicesModel;

  factory ServicesModel.fromJson(Map<String, dynamic> json) =>
      _$ServicesModelFromJson(json);
}
