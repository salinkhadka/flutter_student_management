import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:student_management/core/error/failure.dart';
import 'package:student_management/features/auth/data/data_source/remote_datasource/student_remote_dataSource.dart';
import 'package:student_management/features/auth/domain/entity/student_entity.dart';
import 'package:student_management/features/auth/domain/repository/student_repository.dart';
import 'package:dio/dio.dart';

class StudentRemoteRepository implements IStudentRepository {
  final StudentRemoteDatasource remoteDataSource;

  StudentRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, StudentEntity>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    }
   catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> loginStudent(String username, String password) async {
    try {
      final token = await remoteDataSource.loginStudent(username, password);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  // Updated here: returning Either<Failure, void>
  @override
  Future<Either<Failure, void>> registerStudent(StudentEntity student) async {
    try {
      await remoteDataSource.registerStudent(student);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageUrl = await remoteDataSource.uploadProfilePicture(file.path);
      return Right(imageUrl);
    } on DioException catch (e) {
      return Left(RemoteDatabaseFailure(
        statusCode: e.response?.statusCode,
        message: 'Image upload failed: ${e.message}',
      ));
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Unexpected error: $e'));
    }
  }
}
