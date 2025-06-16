// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getall_course_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetallCourseDto _$GetallCourseDtoFromJson(Map<String, dynamic> json) =>
    GetallCourseDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => CourseApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetallCourseDtoToJson(GetallCourseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
