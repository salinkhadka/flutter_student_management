import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_management/features/batch/domain/entity/batch_entity.dart';

@JsonSerializable()
class BatchApiModel extends Equatable {
  @JsonKey(name: '_id') // Server returns _id
  final String? batchId;
  final String batchName;

  const BatchApiModel({
    this.batchId,
    required this.batchName,
  });

  const BatchApiModel.empty() : batchId = '', batchName = '';

  @override
  List<Object?> get props => [batchId, batchName];

  // From JSON
  factory BatchApiModel.fromJson(Map<String, dynamic> json) {
    return BatchApiModel(
      batchId: json['_id'],
      batchName: json['batchName'],
    );
  }

  // ✅ To JSON (send only ID for backend)
  Map<String, dynamic> toJson() {
    return {
      '_id': batchId, // ✅ Required for MongoDB reference
      'batchName':batchName
    };
  }

  // Convert to Entity
  BatchEntity toEntity() => BatchEntity(
        batchId: batchId,
        batchName: batchName,
      );

  // Convert from Entity
  static BatchApiModel fromEntity(BatchEntity entity) => BatchApiModel(
        batchId: entity.batchId,
        batchName: entity.batchName,
      );

  // List conversion
  static List<BatchEntity> toEntityList(List<BatchApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
