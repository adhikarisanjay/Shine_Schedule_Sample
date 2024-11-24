// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$servicesActivityHash() => r'fe119a28ffbdd58f5db3e8a6252c8871036e2579';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ServicesActivity
    extends BuildlessAutoDisposeAsyncNotifier<BusinessServices?> {
  late final String businessName;

  FutureOr<BusinessServices?> build(
    String businessName,
  );
}

/// See also [ServicesActivity].
@ProviderFor(ServicesActivity)
const servicesActivityProvider = ServicesActivityFamily();

/// See also [ServicesActivity].
class ServicesActivityFamily extends Family<AsyncValue<BusinessServices?>> {
  /// See also [ServicesActivity].
  const ServicesActivityFamily();

  /// See also [ServicesActivity].
  ServicesActivityProvider call(
    String businessName,
  ) {
    return ServicesActivityProvider(
      businessName,
    );
  }

  @override
  ServicesActivityProvider getProviderOverride(
    covariant ServicesActivityProvider provider,
  ) {
    return call(
      provider.businessName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'servicesActivityProvider';
}

/// See also [ServicesActivity].
class ServicesActivityProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ServicesActivity, BusinessServices?> {
  /// See also [ServicesActivity].
  ServicesActivityProvider(
    String businessName,
  ) : this._internal(
          () => ServicesActivity()..businessName = businessName,
          from: servicesActivityProvider,
          name: r'servicesActivityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$servicesActivityHash,
          dependencies: ServicesActivityFamily._dependencies,
          allTransitiveDependencies:
              ServicesActivityFamily._allTransitiveDependencies,
          businessName: businessName,
        );

  ServicesActivityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessName,
  }) : super.internal();

  final String businessName;

  @override
  FutureOr<BusinessServices?> runNotifierBuild(
    covariant ServicesActivity notifier,
  ) {
    return notifier.build(
      businessName,
    );
  }

  @override
  Override overrideWith(ServicesActivity Function() create) {
    return ProviderOverride(
      origin: this,
      override: ServicesActivityProvider._internal(
        () => create()..businessName = businessName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessName: businessName,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ServicesActivity, BusinessServices?>
      createElement() {
    return _ServicesActivityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesActivityProvider &&
        other.businessName == businessName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServicesActivityRef
    on AutoDisposeAsyncNotifierProviderRef<BusinessServices?> {
  /// The parameter `businessName` of this provider.
  String get businessName;
}

class _ServicesActivityProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ServicesActivity,
        BusinessServices?> with ServicesActivityRef {
  _ServicesActivityProviderElement(super.provider);

  @override
  String get businessName => (origin as ServicesActivityProvider).businessName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
