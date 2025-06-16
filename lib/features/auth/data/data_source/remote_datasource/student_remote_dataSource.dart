import 'package:dio/dio.dart';
import 'package:student_management/app/constant/api_endpoints.dart';
import 'package:student_management/core/network/api_service.dart';
import 'package:student_management/features/auth/data/model/student_api_model.dart';
import 'package:student_management/features/auth/domain/entity/student_entity.dart';
import 'package:student_management/features/auth/data/data_source/sudent_data_source.dart';

class StudentRemoteDatasource implements IStudentDataSource {
  final ApiService _apiService;

  StudentRemoteDatasource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<void> registerStudent(StudentEntity studentData) async {
    try {
      final studentApiModel = StudentApiModel.fromEntity(studentData);

      final response = await _apiService.dio.post(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.register}",
        data: studentApiModel.toJson(),
      );

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to register student: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error while registering student: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> loginStudent(String username, String password) async {
    try {
      final response = await _apiService.dio.post(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.login}",
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error while logging in: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<StudentEntity> getCurrentUser() async {
    try {
      final response = await _apiService.dio.get(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.getAllStudent}",
      );

      if (response.statusCode == 200) {
        final student = StudentApiModel.fromJson(response.data);
        return student.toEntity();
      } else {
        throw Exception('Failed to fetch student info: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: 'profile.jpg'),
      });

      final response = await _apiService.dio.post(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.uploadImage}",
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['imageUrl'];
      } else {
        throw Exception('Image upload failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error during image upload: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
