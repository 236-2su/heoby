// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayForecastHash() => r'cbe35c7dcb9588dd932d15bdf4705a9ac9411eb1';

/// 오늘 날씨 예보 Provider
/// 선택된 허수아비의 날씨 예보를 가져옴
///
/// Copied from [todayForecast].
@ProviderFor(todayForecast)
final todayForecastProvider = AutoDisposeFutureProvider<WeatherEntity>.internal(
  todayForecast,
  name: r'todayForecastProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayForecastHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayForecastRef = AutoDisposeFutureProviderRef<WeatherEntity>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
