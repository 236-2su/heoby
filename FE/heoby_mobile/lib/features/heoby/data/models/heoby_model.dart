import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heoby_mobile/core/models/location.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';

part 'heoby_model.freezed.dart';
part 'heoby_model.g.dart';

// 단일 허수아비 모델
@freezed
class HeobyModel with _$HeobyModel {
  const factory HeobyModel({
    @JsonKey(name: 'scarecrow_uuid') required String scarecrowUuid,
    required String name,
    required Location location,
    @JsonKey(name: 'owner_name') required String ownerName,
    required String status,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'serial_number') required String serialNumber,
    required double? temperature,
    required double? humidity,
    required bool? camera,
    required bool? heatDetection,
    required bool? voice,
    required double? battery,
  }) = _HeobyModel;

  factory HeobyModel.fromJson(Map<String, dynamic> json) => _$HeobyModelFromJson(json);
}

// Model → Entity 변환 Mapper
extension HeobyModelX on HeobyModel {
  HeobyEntity toEntity({required bool isOwner}) => HeobyEntity(
    uuid: scarecrowUuid,
    name: name,
    location: location,
    ownerName: ownerName,
    status: status,
    updatedAt: updatedAt,
    temperature: temperature,
    humidity: humidity,
    camera: camera,
    heatDetection: heatDetection,
    voice: voice,
    battery: battery,
    serialNumber: serialNumber,
    isOwner: isOwner,
  );
}

// API 응답 전체 모델
@freezed
class HeobyListResponse with _$HeobyListResponse {
  const HeobyListResponse._(); // private constructor for methods

  const factory HeobyListResponse({
    @JsonKey(name: 'my_scarecrows') required List<HeobyModel> myScarecrows,
    @JsonKey(name: 'village_scarecrows') required List<HeobyModel> villageScarecrows,
  }) = _HeobyListResponse;

  factory HeobyListResponse.fromJson(Map<String, dynamic> json) => _$HeobyListResponseFromJson(json);

  /// 내 허수아비 목록
  List<HeobyEntity> get myScarecrowEntities => myScarecrows.map((model) => model.toEntity(isOwner: true)).toList();

  /// 마을 허수아비 목록
  List<HeobyEntity> get villageScarecrowEntities =>
      villageScarecrows.map((model) => model.toEntity(isOwner: false)).toList();

  /// 전체 허수아비 목록
  List<HeobyEntity> get allScarecrowEntities => [...myScarecrowEntities, ...villageScarecrowEntities];
}
