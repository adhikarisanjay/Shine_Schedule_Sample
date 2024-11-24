// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceCategoriesModelImpl _$$ServiceCategoriesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceCategoriesModelImpl(
      name: json['name'] as String,
      services: (json['services'] as List<dynamic>)
          .map((e) => ServicesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ServiceCategoriesModelImplToJson(
        _$ServiceCategoriesModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'services': instance.services,
    };
