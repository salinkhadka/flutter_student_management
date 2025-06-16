import 'package:json_annotation/json_annotation.dart';
import 'package:student_management/features/batch/data/model/batch_api_model.dart';
import 'package:student_management/features/course/data/model/course_api_model.dart';

part 'getall_course_dto.g.dart';

@JsonSerializable()
class GetallCourseDto {
  final bool success;
  final int count;
  final List<CourseApiModel> data;

  GetallCourseDto({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetallCourseDto.fromJson(Map<String, dynamic> json) =>
      _$GetallCourseDtoFromJson(json); // fixed typo

  Map<String, dynamic> toJson() => _$GetallCourseDtoToJson(this); // fixed method name
}
