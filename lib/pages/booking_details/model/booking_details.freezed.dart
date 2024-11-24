// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingDetails _$BookingDetailsFromJson(Map<String, dynamic> json) {
  return _BookingDetails.fromJson(json);
}

/// @nodoc
mixin _$BookingDetails {
  String get id => throw _privateConstructorUsedError;
  dynamic get amount => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp get date => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String get paymentConfirmation => throw _privateConstructorUsedError;
  String get serviceName => throw _privateConstructorUsedError;
  @TimestampListConverter()
  List<Timestamp> get time => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingDetailsCopyWith<BookingDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDetailsCopyWith<$Res> {
  factory $BookingDetailsCopyWith(
          BookingDetails value, $Res Function(BookingDetails) then) =
      _$BookingDetailsCopyWithImpl<$Res, BookingDetails>;
  @useResult
  $Res call(
      {String id,
      dynamic amount,
      @TimestampConverter() Timestamp date,
      String email,
      String? status,
      String paymentConfirmation,
      String serviceName,
      @TimestampListConverter() List<Timestamp> time,
      String userName,
      String? imageUrl,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$BookingDetailsCopyWithImpl<$Res, $Val extends BookingDetails>
    implements $BookingDetailsCopyWith<$Res> {
  _$BookingDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = freezed,
    Object? date = null,
    Object? email = null,
    Object? status = freezed,
    Object? paymentConfirmation = null,
    Object? serviceName = null,
    Object? time = null,
    Object? userName = null,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentConfirmation: null == paymentConfirmation
          ? _value.paymentConfirmation
          : paymentConfirmation // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as List<Timestamp>,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingDetailsImplCopyWith<$Res>
    implements $BookingDetailsCopyWith<$Res> {
  factory _$$BookingDetailsImplCopyWith(_$BookingDetailsImpl value,
          $Res Function(_$BookingDetailsImpl) then) =
      __$$BookingDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      dynamic amount,
      @TimestampConverter() Timestamp date,
      String email,
      String? status,
      String paymentConfirmation,
      String serviceName,
      @TimestampListConverter() List<Timestamp> time,
      String userName,
      String? imageUrl,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$BookingDetailsImplCopyWithImpl<$Res>
    extends _$BookingDetailsCopyWithImpl<$Res, _$BookingDetailsImpl>
    implements _$$BookingDetailsImplCopyWith<$Res> {
  __$$BookingDetailsImplCopyWithImpl(
      _$BookingDetailsImpl _value, $Res Function(_$BookingDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = freezed,
    Object? date = null,
    Object? email = null,
    Object? status = freezed,
    Object? paymentConfirmation = null,
    Object? serviceName = null,
    Object? time = null,
    Object? userName = null,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$BookingDetailsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentConfirmation: null == paymentConfirmation
          ? _value.paymentConfirmation
          : paymentConfirmation // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value._time
          : time // ignore: cast_nullable_to_non_nullable
              as List<Timestamp>,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingDetailsImpl implements _BookingDetails {
  const _$BookingDetailsImpl(
      {required this.id,
      required this.amount,
      @TimestampConverter() required this.date,
      required this.email,
      this.status,
      required this.paymentConfirmation,
      required this.serviceName,
      @TimestampListConverter() required final List<Timestamp> time,
      required this.userName,
      this.imageUrl,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy})
      : _time = time;

  factory _$BookingDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingDetailsImplFromJson(json);

  @override
  final String id;
  @override
  final dynamic amount;
  @override
  @TimestampConverter()
  final Timestamp date;
  @override
  final String email;
  @override
  final String? status;
  @override
  final String paymentConfirmation;
  @override
  final String serviceName;
  final List<Timestamp> _time;
  @override
  @TimestampListConverter()
  List<Timestamp> get time {
    if (_time is EqualUnmodifiableListView) return _time;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_time);
  }

  @override
  final String userName;
  @override
  final String? imageUrl;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'BookingDetails(id: $id, amount: $amount, date: $date, email: $email, status: $status, paymentConfirmation: $paymentConfirmation, serviceName: $serviceName, time: $time, userName: $userName, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.amount, amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentConfirmation, paymentConfirmation) ||
                other.paymentConfirmation == paymentConfirmation) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            const DeepCollectionEquality().equals(other._time, _time) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(amount),
      date,
      email,
      status,
      paymentConfirmation,
      serviceName,
      const DeepCollectionEquality().hash(_time),
      userName,
      imageUrl,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDetailsImplCopyWith<_$BookingDetailsImpl> get copyWith =>
      __$$BookingDetailsImplCopyWithImpl<_$BookingDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingDetailsImplToJson(
      this,
    );
  }
}

abstract class _BookingDetails implements BookingDetails {
  const factory _BookingDetails(
      {required final String id,
      required final dynamic amount,
      @TimestampConverter() required final Timestamp date,
      required final String email,
      final String? status,
      required final String paymentConfirmation,
      required final String serviceName,
      @TimestampListConverter() required final List<Timestamp> time,
      required final String userName,
      final String? imageUrl,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$BookingDetailsImpl;

  factory _BookingDetails.fromJson(Map<String, dynamic> json) =
      _$BookingDetailsImpl.fromJson;

  @override
  String get id;
  @override
  dynamic get amount;
  @override
  @TimestampConverter()
  Timestamp get date;
  @override
  String get email;
  @override
  String? get status;
  @override
  String get paymentConfirmation;
  @override
  String get serviceName;
  @override
  @TimestampListConverter()
  List<Timestamp> get time;
  @override
  String get userName;
  @override
  String? get imageUrl;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  @JsonKey(ignore: true)
  _$$BookingDetailsImplCopyWith<_$BookingDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
