import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_management/features/course/domain/entity/course_entity.dart';

@JsonSerializable()
class CourseApiModel extends Equatable {
  @JsonKey(name: '_id') // Maps the server _id field
  final String? courseId;
  final String courseName;

  const CourseApiModel({
    this.courseId,
    required this.courseName,
  });

  @override
  List<Object?> get props => [courseId, courseName];

  // From JSON
  factory CourseApiModel.fromJson(Map<String, dynamic> json) {
    return CourseApiModel(
      courseId: json['_id'],
      courseName: json['courseName'],
    );
  }

  // ✅ To JSON: Send only the ID to backend
  Map<String, dynamic> toJson() {
    return {
      '_id': courseId, // ✅ Required for referencing in MongoDB
    };
  }

  // Convert API Object to Entity
  CourseEntity toEntity() => CourseEntity(
        courseId: courseId,
        courseName: courseName,
      );

  // Convert Entity to API Object
  static CourseApiModel fromEntity(CourseEntity entity) => CourseApiModel(
        courseId: entity.courseId,
        courseName: entity.courseName,
      );

  // Convert API List to Entity List
  static List<CourseEntity> toEntityList(List<CourseApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
