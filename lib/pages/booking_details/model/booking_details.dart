import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'booking_details.freezed.dart';
part 'booking_details.g.dart';

@freezed
class BookingDetails with _$BookingDetails {
  const factory BookingDetails({
    required String id,
    required dynamic amount,
    @TimestampConverter() required Timestamp date,
    required String email,
    String? status,
    required String paymentConfirmation,
    required String serviceName,
    @TimestampListConverter() required List<Timestamp> time,
    required String userName,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _BookingDetails;

  factory BookingDetails.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsFromJson(json);

  factory BookingDetails.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingDetails(
      id: doc.id,
      amount: data['amount'] as dynamic ?? 0.0,
      date: data['date'] as Timestamp,
      email: data['email'] as String? ?? '',
      status: data['status'] as String?,
      paymentConfirmation: data['paymentConfirmation'] as String? ?? '',
      serviceName: data['serviceName'] as String? ?? '',
      time: (data['time'] as List<dynamic>).map((e) => e as Timestamp).toList(),
      userName: data['userName'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      createdBy: data['createdBy'] as String?,
      updatedBy: data['updatedBy'] as String?,
    );
  }
}

class TimestampConverter implements JsonConverter<Timestamp, Object> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Object json) {
    if (json is Timestamp) {
      return json;
    } else if (json is Map<String, dynamic>) {
      return Timestamp.fromMillisecondsSinceEpoch(
          (json['seconds'] as int) * 1000 +
              (json['nanoseconds'] as int) ~/ 1000000);
    } else {
      throw ArgumentError('Invalid format for Timestamp');
    }
  }

  @override
  Object toJson(Timestamp timestamp) => timestamp;
}

class TimestampListConverter
    implements JsonConverter<List<Timestamp>, List<dynamic>> {
  const TimestampListConverter();

  @override
  List<Timestamp> fromJson(List<dynamic> json) {
    return json.map((e) => TimestampConverter().fromJson(e)).toList();
  }

  @override
  List<dynamic> toJson(List<Timestamp> timestamps) {
    return timestamps
        .map((timestamp) => TimestampConverter().toJson(timestamp))
        .toList();
  }
}
