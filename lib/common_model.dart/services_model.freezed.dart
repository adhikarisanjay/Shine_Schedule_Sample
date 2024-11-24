// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'services_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServicesModel _$ServicesModelFromJson(Map<String, dynamic> json) {
  return _ServicesModel.fromJson(json);
}

/// @nodoc
mixin _$ServicesModel {
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServicesModelCopyWith<ServicesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServicesModelCopyWith<$Res> {
  factory $ServicesModelCopyWith(
          ServicesModel value, $Res Function(ServicesModel) then) =
      _$ServicesModelCopyWithImpl<$Res, ServicesModel>;
  @useResult
  $Res call(
      {String name,
      String category,
      String description,
      double price,
      int duration});
}

/// @nodoc
class _$ServicesModelCopyWithImpl<$Res, $Val extends ServicesModel>
    implements $ServicesModelCopyWith<$Res> {
  _$ServicesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? description = null,
    Object? price = null,
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServicesModelImplCopyWith<$Res>
    implements $ServicesModelCopyWith<$Res> {
  factory _$$ServicesModelImplCopyWith(
          _$ServicesModelImpl value, $Res Function(_$ServicesModelImpl) then) =
      __$$ServicesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String category,
      String description,
      double price,
      int duration});
}

/// @nodoc
class __$$ServicesModelImplCopyWithImpl<$Res>
    extends _$ServicesModelCopyWithImpl<$Res, _$ServicesModelImpl>
    implements _$$ServicesModelImplCopyWith<$Res> {
  __$$ServicesModelImplCopyWithImpl(
      _$ServicesModelImpl _value, $Res Function(_$ServicesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? description = null,
    Object? price = null,
    Object? duration = null,
  }) {
    return _then(_$ServicesModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServicesModelImpl implements _ServicesModel {
  const _$ServicesModelImpl(
      {required this.name,
      required this.category,
      required this.description,
      required this.price,
      required this.duration});

  factory _$ServicesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServicesModelImplFromJson(json);

  @override
  final String name;
  @override
  final String category;
  @override
  final String description;
  @override
  final double price;
  @override
  final int duration;

  @override
  String toString() {
    return 'ServicesModel(name: $name, category: $category, description: $description, price: $price, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServicesModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, category, description, price, duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServicesModelImplCopyWith<_$ServicesModelImpl> get copyWith =>
      __$$ServicesModelImplCopyWithImpl<_$ServicesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServicesModelImplToJson(
      this,
    );
  }
}

abstract class _ServicesModel implements ServicesModel {
  const factory _ServicesModel(
      {required final String name,
      required final String category,
      required final String description,
      required final double price,
      required final int duration}) = _$ServicesModelImpl;

  factory _ServicesModel.fromJson(Map<String, dynamic> json) =
      _$ServicesModelImpl.fromJson;

  @override
  String get name;
  @override
  String get category;
  @override
  String get description;
  @override
  double get price;
  @override
  int get duration;
  @override
  @JsonKey(ignore: true)
  _$$ServicesModelImplCopyWith<_$ServicesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
