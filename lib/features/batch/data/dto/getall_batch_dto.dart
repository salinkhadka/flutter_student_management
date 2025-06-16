import 'package:json_annotation/json_annotation.dart';
import 'package:student_management/features/batch/data/model/batch_api_model.dart';

part 'getall_batch_dto.g.dart';

@JsonSerializable()
class GetallBatchDto {
  final bool success;
  final int count;
  final List<BatchApiModel> data;

  GetallBatchDto({required this.success, required this.count, required this.data});

  Map<String, dynamic> toJson() => _$GetallBatchDtoToJson(this);

  factory GetallBatchDto.fromJson(Map<String, dynamic> json) =>
      _$GetallBatchDtoFromJson(json);
}
