import 'package:equatable/equatable.dart';
import 'package:student_management/features/auth/domain/entity/student_entity.dart';
import 'package:student_management/features/batch/data/model/batch_api_model.dart';
import 'package:student_management/features/course/data/model/course_api_model.dart';

class StudentApiModel extends Equatable {
  final String? userId;
  final String fName;
  final String lName;
  final String? image;
  final String phone;
  final BatchApiModel batch;
  final List<CourseApiModel> course;
  final String username;
  final String password;

  const StudentApiModel({
    this.userId,
    required this.fName,
    required this.lName,
    this.image,
    required this.phone,
    required this.batch,
    required this.course,
    required this.username,
    required this.password,
  });

  const StudentApiModel.empty()
      : userId = '',
        fName = '',
        lName = '',
        image = '',
        phone = '',
        batch = const BatchApiModel.empty(),
        course = const [],
        username = '',
        password = '';

  @override
  List<Object?> get props => [
        userId,
        fName,
        lName,
        image,
        phone,
        batch,
        course,
        username,
        password,
      ];

  // ✅ Updated fromJson
  factory StudentApiModel.fromJson(Map<String, dynamic> json) {
    return StudentApiModel(
      userId: json['_id'] as String?,
      fName: json['fname'] as String, // ✅ lowercase
      lName: json['lname'] as String, // ✅ lowercase
      image: json['image'] as String?,
      phone: json['phone'] as String,
      batch: json['batch'] != null
          ? BatchApiModel.fromJson(json['batch'])
          : const BatchApiModel.empty(),
      course: json['course'] != null
          ? (json['course'] as List)
              .map((e) => CourseApiModel.fromJson(e))
              .toList()
          : [],
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }

  // ✅ Updated toJson
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) '_id': userId,
      'fname': fName, // ✅ lowercase
      'lname': lName, // ✅ lowercase
      'image': image,
      'phone': phone,
      'batch': batch.batchId,
      'course': course.map((c) => c.courseId).toList(),
      'username': username,
      'password': password,
    };
  }

  // Convert API Model to Entity
  StudentEntity toEntity() => StudentEntity(
        userId: userId,
        fName: fName,
        lName: lName,
        image: image,
        phone: phone,
        batch: batch.toEntity(),
        courses: course.map((e) => e.toEntity()).toList(),
        username: username,
        password: password,
      );

  // Convert Entity to API Model
  static StudentApiModel fromEntity(StudentEntity entity) => StudentApiModel(
        userId: entity.userId,
        fName: entity.fName,
        lName: entity.lName,
        image: entity.image,
        phone: entity.phone,
        batch: BatchApiModel.fromEntity(entity.batch),
        course: entity.courses.map(CourseApiModel.fromEntity).toList(),
        username: entity.username,
        password: entity.password,
      );

  static List<StudentEntity> toEntityList(List<StudentApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
