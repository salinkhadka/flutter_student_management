// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getall_batch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetallBatchDto _$GetallBatchDtoFromJson(Map<String, dynamic> json) =>
    GetallBatchDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => BatchApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetallBatchDtoToJson(GetallBatchDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
