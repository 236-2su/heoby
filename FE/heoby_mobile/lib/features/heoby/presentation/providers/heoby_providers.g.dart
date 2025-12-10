// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heoby_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$heobyListHash() => r'20b00806ca608e0a28ca4ba6705777620d66017f';

/// 전체 허수아비 목록 Provider
/// 내 허수아비가 먼저, 마을 허수아비가 나중에 표시됨
///
/// Copied from [heobyList].
@ProviderFor(heobyList)
final heobyListProvider = AutoDisposeFutureProvider<List<HeobyEntity>>.internal(
  heobyList,
  name: r'heobyListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$heobyListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HeobyListRef = AutoDisposeFutureProviderRef<List<HeobyEntity>>;
String _$selectedHeobyHash() => r'4383a656ec7cf17b37c32ef5dc486cc7624324a3';

/// 선택된 허수아비 ID Provider
/// 날씨, 지도 등에서 선택된 허수아비의 정보를 보여줄 때 사용
///
/// Copied from [SelectedHeoby].
@ProviderFor(SelectedHeoby)
final selectedHeobyProvider =
    AutoDisposeNotifierProvider<SelectedHeoby, HeobyEntity?>.internal(
      SelectedHeoby.new,
      name: r'selectedHeobyProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedHeobyHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedHeoby = AutoDisposeNotifier<HeobyEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
