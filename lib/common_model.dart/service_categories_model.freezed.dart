// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_categories_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceCategoriesModel _$ServiceCategoriesModelFromJson(
    Map<String, dynamic> json) {
  return _ServiceCategoriesModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceCategoriesModel {
  String get name => throw _privateConstructorUsedError;
  List<ServicesModel> get services => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceCategoriesModelCopyWith<ServiceCategoriesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceCategoriesModelCopyWith<$Res> {
  factory $ServiceCategoriesModelCopyWith(ServiceCategoriesModel value,
          $Res Function(ServiceCategoriesModel) then) =
      _$ServiceCategoriesModelCopyWithImpl<$Res, ServiceCategoriesModel>;
  @useResult
  $Res call({String name, List<ServicesModel> services});
}

/// @nodoc
class _$ServiceCategoriesModelCopyWithImpl<$Res,
        $Val extends ServiceCategoriesModel>
    implements $ServiceCategoriesModelCopyWith<$Res> {
  _$ServiceCategoriesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? services = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServicesModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceCategoriesModelImplCopyWith<$Res>
    implements $ServiceCategoriesModelCopyWith<$Res> {
  factory _$$ServiceCategoriesModelImplCopyWith(
          _$ServiceCategoriesModelImpl value,
          $Res Function(_$ServiceCategoriesModelImpl) then) =
      __$$ServiceCategoriesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<ServicesModel> services});
}

/// @nodoc
class __$$ServiceCategoriesModelImplCopyWithImpl<$Res>
    extends _$ServiceCategoriesModelCopyWithImpl<$Res,
        _$ServiceCategoriesModelImpl>
    implements _$$ServiceCategoriesModelImplCopyWith<$Res> {
  __$$ServiceCategoriesModelImplCopyWithImpl(
      _$ServiceCategoriesModelImpl _value,
      $Res Function(_$ServiceCategoriesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? services = null,
  }) {
    return _then(_$ServiceCategoriesModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServicesModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceCategoriesModelImpl implements _ServiceCategoriesModel {
  const _$ServiceCategoriesModelImpl(
      {required this.name, required final List<ServicesModel> services})
      : _services = services;

  factory _$ServiceCategoriesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceCategoriesModelImplFromJson(json);

  @override
  final String name;
  final List<ServicesModel> _services;
  @override
  List<ServicesModel> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  String toString() {
    return 'ServiceCategoriesModel(name: $name, services: $services)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceCategoriesModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._services, _services));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_services));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceCategoriesModelImplCopyWith<_$ServiceCategoriesModelImpl>
      get copyWith => __$$ServiceCategoriesModelImplCopyWithImpl<
          _$ServiceCategoriesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceCategoriesModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceCategoriesModel implements ServiceCategoriesModel {
  const factory _ServiceCategoriesModel(
          {required final String name,
          required final List<ServicesModel> services}) =
      _$ServiceCategoriesModelImpl;

  factory _ServiceCategoriesModel.fromJson(Map<String, dynamic> json) =
      _$ServiceCategoriesModelImpl.fromJson;

  @override
  String get name;
  @override
  List<ServicesModel> get services;
  @override
  @JsonKey(ignore: true)
  _$$ServiceCategoriesModelImplCopyWith<_$ServiceCategoriesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
