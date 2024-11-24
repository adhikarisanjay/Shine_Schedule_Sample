// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingDetailsImpl _$$BookingDetailsImplFromJson(Map<String, dynamic> json) =>
    _$BookingDetailsImpl(
      id: json['id'] as String,
      amount: json['amount'],
      date: const TimestampConverter().fromJson(json['date'] as Object),
      email: json['email'] as String,
      status: json['status'] as String?,
      paymentConfirmation: json['paymentConfirmation'] as String,
      serviceName: json['serviceName'] as String,
      time: const TimestampListConverter().fromJson(json['time'] as List),
      userName: json['userName'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$BookingDetailsImplToJson(
        _$BookingDetailsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'date': const TimestampConverter().toJson(instance.date),
      'email': instance.email,
      'status': instance.status,
      'paymentConfirmation': instance.paymentConfirmation,
      'serviceName': instance.serviceName,
      'time': const TimestampListConverter().toJson(instance.time),
      'userName': instance.userName,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };
