import 'package:heoby_mobile/features/cctv/domain/entities/workers_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workers_model.g.dart';

@JsonSerializable()
class WorkersModel {
  final int workers;

  WorkersModel({
    required this.workers,
  });

  factory WorkersModel.fromJson(Map<String, dynamic> json) => _$WorkersModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkersModelToJson(this);

  /// Convert DTO to Domain Entity
  WorkersEntity toEntity() {
    return WorkersEntity(
      workers: workers,
    );
  }
}
