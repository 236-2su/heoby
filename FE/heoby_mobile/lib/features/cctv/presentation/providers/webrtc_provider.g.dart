// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webrtc_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webrtcServiceHash() => r'50f8caf7b5652eb1a86a98b0e5eb33f2128be053';

/// WebRTC 서비스 Provider (WHEP 기반)
///
/// Copied from [webrtcService].
@ProviderFor(webrtcService)
final webrtcServiceProvider = AutoDisposeProvider<WebRTCService>.internal(
  webrtcService,
  name: r'webrtcServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$webrtcServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WebrtcServiceRef = AutoDisposeProviderRef<WebRTCService>;
String _$cctvStreamHash() => r'bc5b5f3234317211110604e18ae1d48f7770394a';

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

/// CCTV 스트림 Provider
///
/// Copied from [cctvStream].
@ProviderFor(cctvStream)
const cctvStreamProvider = CctvStreamFamily();

/// CCTV 스트림 Provider
///
/// Copied from [cctvStream].
class CctvStreamFamily extends Family<AsyncValue<MediaStream>> {
  /// CCTV 스트림 Provider
  ///
  /// Copied from [cctvStream].
  const CctvStreamFamily();

  /// CCTV 스트림 Provider
  ///
  /// Copied from [cctvStream].
  CctvStreamProvider call(String serialNumber) {
    return CctvStreamProvider(serialNumber);
  }

  @override
  CctvStreamProvider getProviderOverride(
    covariant CctvStreamProvider provider,
  ) {
    return call(provider.serialNumber);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cctvStreamProvider';
}

/// CCTV 스트림 Provider
///
/// Copied from [cctvStream].
class CctvStreamProvider extends AutoDisposeStreamProvider<MediaStream> {
  /// CCTV 스트림 Provider
  ///
  /// Copied from [cctvStream].
  CctvStreamProvider(String serialNumber)
    : this._internal(
        (ref) => cctvStream(ref as CctvStreamRef, serialNumber),
        from: cctvStreamProvider,
        name: r'cctvStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$cctvStreamHash,
        dependencies: CctvStreamFamily._dependencies,
        allTransitiveDependencies: CctvStreamFamily._allTransitiveDependencies,
        serialNumber: serialNumber,
      );

  CctvStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serialNumber,
  }) : super.internal();

  final String serialNumber;

  @override
  Override overrideWith(
    Stream<MediaStream> Function(CctvStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CctvStreamProvider._internal(
        (ref) => create(ref as CctvStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serialNumber: serialNumber,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<MediaStream> createElement() {
    return _CctvStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CctvStreamProvider && other.serialNumber == serialNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serialNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CctvStreamRef on AutoDisposeStreamProviderRef<MediaStream> {
  /// The parameter `serialNumber` of this provider.
  String get serialNumber;
}

class _CctvStreamProviderElement
    extends AutoDisposeStreamProviderElement<MediaStream>
    with CctvStreamRef {
  _CctvStreamProviderElement(super.provider);

  @override
  String get serialNumber => (origin as CctvStreamProvider).serialNumber;
}

String _$webrtcConnectionHash() => r'ffae9813eeef5a4872a42b473535596276a3a5fa';

/// WebRTC 연결 상태
///
/// Copied from [WebrtcConnection].
@ProviderFor(WebrtcConnection)
final webrtcConnectionProvider =
    AutoDisposeNotifierProvider<WebrtcConnection, RTCStatus>.internal(
      WebrtcConnection.new,
      name: r'webrtcConnectionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$webrtcConnectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WebrtcConnection = AutoDisposeNotifier<RTCStatus>;
String _$connectedCctvHash() => r'b315abd1ffd5068380bb0f508f532c07831b605f';

/// 현재 연결된 CCTV Serial Number
///
/// Copied from [ConnectedCctv].
@ProviderFor(ConnectedCctv)
final connectedCctvProvider =
    AutoDisposeNotifierProvider<ConnectedCctv, String?>.internal(
      ConnectedCctv.new,
      name: r'connectedCctvProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectedCctvHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ConnectedCctv = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
