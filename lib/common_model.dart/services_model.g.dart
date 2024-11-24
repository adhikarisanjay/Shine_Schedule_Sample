// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServicesModelImpl _$$ServicesModelImplFromJson(Map<String, dynamic> json) =>
    _$ServicesModelImpl(
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as int,
    );

Map<String, dynamic> _$$ServicesModelImplToJson(_$ServicesModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'price': instance.price,
      'duration': instance.duration,
    };
