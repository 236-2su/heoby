import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/location.dart';

part 'heoby_entity.freezed.dart';
// part 'heoby_entity.g.dart';

@freezed
class HeobyEntity with _$HeobyEntity {
  const HeobyEntity._();

  const factory HeobyEntity({
    required String uuid,
    required String name,
    required Location location,
    required String ownerName,
    required String status,
    required String updatedAt,
    required double? temperature,
    required double? humidity,
    required bool? camera,
    required bool? heatDetection,
    required bool? voice,
    required double? battery,
    // required bool isOwner,
    required String? serialNumber,
    required bool isOwner,
  }) = _HeobyEntity;
}
