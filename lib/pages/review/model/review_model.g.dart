// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      serviceName: json['serviceName'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewDescription: json['reviewDescription'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'serviceName': instance.serviceName,
      'rating': instance.rating,
      'reviewDescription': instance.reviewDescription,
      'userName': instance.userName,
      'email': instance.email,
    };
