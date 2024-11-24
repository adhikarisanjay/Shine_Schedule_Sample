// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessModel _$BusinessModelFromJson(Map<String, dynamic> json) {
  return _BusinessModel.fromJson(json);
}

/// @nodoc
mixin _$BusinessModel {
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessModelCopyWith<BusinessModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessModelCopyWith<$Res> {
  factory $BusinessModelCopyWith(
          BusinessModel value, $Res Function(BusinessModel) then) =
      _$BusinessModelCopyWithImpl<$Res, BusinessModel>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$BusinessModelCopyWithImpl<$Res, $Val extends BusinessModel>
    implements $BusinessModelCopyWith<$Res> {
  _$BusinessModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessModelImplCopyWith<$Res>
    implements $BusinessModelCopyWith<$Res> {
  factory _$$BusinessModelImplCopyWith(
          _$BusinessModelImpl value, $Res Function(_$BusinessModelImpl) then) =
      __$$BusinessModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$BusinessModelImplCopyWithImpl<$Res>
    extends _$BusinessModelCopyWithImpl<$Res, _$BusinessModelImpl>
    implements _$$BusinessModelImplCopyWith<$Res> {
  __$$BusinessModelImplCopyWithImpl(
      _$BusinessModelImpl _value, $Res Function(_$BusinessModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$BusinessModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessModelImpl implements _BusinessModel {
  const _$BusinessModelImpl({required this.name});

  factory _$BusinessModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessModelImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'BusinessModel(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessModelImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessModelImplCopyWith<_$BusinessModelImpl> get copyWith =>
      __$$BusinessModelImplCopyWithImpl<_$BusinessModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessModelImplToJson(
      this,
    );
  }
}

abstract class _BusinessModel implements BusinessModel {
  const factory _BusinessModel({required final String name}) =
      _$BusinessModelImpl;

  factory _BusinessModel.fromJson(Map<String, dynamic> json) =
      _$BusinessModelImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$BusinessModelImplCopyWith<_$BusinessModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
