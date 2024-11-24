import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shine_schedule/common_model.dart/services_model.dart';
part 'service_categories_model.freezed.dart';
part 'service_categories_model.g.dart';

@freezed
class ServiceCategoriesModel with _$ServiceCategoriesModel {
  const factory ServiceCategoriesModel(
      {required String name,
      required List<ServicesModel> services}) = _ServiceCategoriesModel;

  factory ServiceCategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoriesModelFromJson(json);
}
