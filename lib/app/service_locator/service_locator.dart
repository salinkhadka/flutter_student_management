import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:student_management/core/network/api_service.dart';
import 'package:student_management/core/network/hive_service.dart';
import 'package:student_management/features/auth/data/data_source/local_datasource/student_local_datasource.dart';
import 'package:student_management/features/auth/data/data_source/remote_datasource/student_remote_dataSource.dart';
import 'package:student_management/features/auth/data/repository/local_repository/student_local_repository.dart';
import 'package:student_management/features/auth/data/repository/remote_repository/student_remote_repository.dart';
import 'package:student_management/features/auth/domain/repository/student_repository.dart';
import 'package:student_management/features/auth/domain/use_case/student_get_current_usecase.dart';
import 'package:student_management/features/auth/domain/use_case/student_image_upload_usecase.dart';
import 'package:student_management/features/auth/domain/use_case/student_login_usecase.dart';
import 'package:student_management/features/auth/domain/use_case/student_register_usecase.dart';
import 'package:student_management/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:student_management/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:student_management/features/batch/data/data_source/local_datasource/batch_local_datasource.dart';
import 'package:student_management/features/batch/data/data_source/remote_datasource/batch_remote_data_source.dart';
import 'package:student_management/features/batch/data/repository/local_repository/batch_local_repository.dart';
import 'package:student_management/features/batch/data/repository/remote_repository/batch_remote_repository.dart';
import 'package:student_management/features/batch/domain/use_case/create_batch_usecase.dart';
import 'package:student_management/features/batch/domain/use_case/delete_batch_usecase.dart';
import 'package:student_management/features/batch/domain/use_case/get_all_batch_usecase.dart';
import 'package:student_management/features/batch/presentation/view_model/batch_view_model.dart';
import 'package:student_management/features/course/data/data_source/local_datasource/course_local_data_source.dart';
import 'package:student_management/features/course/data/data_source/remote_datasource/course_remote_data_source.dart';
import 'package:student_management/features/course/data/repository/local_repository/course_local_repository.dart';
import 'package:student_management/features/course/data/repository/remote_repository/course_remote_repository.dart';
import 'package:student_management/features/course/domain/use_case/create_course_usecase.dart';
import 'package:student_management/features/course/domain/use_case/delete_course_usecase.dart';
import 'package:student_management/features/course/domain/use_case/get_all_course_usecase.dart';
import 'package:student_management/features/course/presentation/view_model/course_view_model.dart';
import 'package:student_management/features/home/presentation/view_model/home_view_model.dart';
import 'package:student_management/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initApiModule();

  await _initHiveService();
  await _initCourseModule();
  await _initBatchModule();
  await _initAuthModule();
  await _initHomeModule();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}
Future<void> _initApiModule() async {
  serviceLocator.registerLazySingleton(() => Dio()); // Register Dio
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}


Future<void> _initCourseModule() async {
  // Local DataSource
  serviceLocator.registerFactory<CourseLocalDataSource>(
    () => CourseLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  // Local Repository
  serviceLocator.registerFactory<CourseLocalRepository>(
    () => CourseLocalRepository(
      courseLocalDataSource: serviceLocator<CourseLocalDataSource>(),
    ),
  );

  // Remote DataSource
  serviceLocator.registerFactory<CourseRemoteDataSource>(
    () => CourseRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Remote Repository
  serviceLocator.registerFactory<CourseRemoteRepository>(
    () => CourseRemoteRepository(
      remoteDataSource: serviceLocator<CourseRemoteDataSource>(),
    ),
  );

  // UseCases using RemoteRepository — swap to CourseLocalRepository if needed
  serviceLocator.registerFactory<GetAllCourseUsecase>(
    () => GetAllCourseUsecase(
      courseRepository: serviceLocator<CourseRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory<CreateCourseUsecase>(
    () => CreateCourseUsecase(
      courseRepository: serviceLocator<CourseRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory<DeleteCourseUsecase>(
    () => DeleteCourseUsecase(
      courseRepository: serviceLocator<CourseRemoteRepository>(),
    ),
  );

  // ViewModel
  serviceLocator.registerFactory<CourseViewModel>(
    () => CourseViewModel(
      getAllCourseUsecase: serviceLocator<GetAllCourseUsecase>(),
      createCourseUsecase: serviceLocator<CreateCourseUsecase>(),
      deleteCourseUsecase: serviceLocator<DeleteCourseUsecase>(),
    ),
  );
}


Future<void> _initBatchModule() async {
  serviceLocator.registerFactory(
    () => BatchRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory<BatchRemoteRepository>(
    () => BatchRemoteRepository(
      remoteDataSource: serviceLocator<BatchRemoteDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetAllBatchUsecase(
      batchRepository: serviceLocator<BatchRemoteRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => CreateBatchUsecase(
      batchRepository: serviceLocator<BatchRemoteRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => DeleteBatchUsecase(
      batchRepository: serviceLocator<BatchRemoteRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => BatchViewModel(
      getAllBatchUsecase: serviceLocator<GetAllBatchUsecase>(),
      createBatchUsecase: serviceLocator<CreateBatchUsecase>(),
      deleteBatchUsecase: serviceLocator<DeleteBatchUsecase>(),
    ),
  );
}


Future<void> _initAuthModule() async {
  // Data sources
  serviceLocator.registerFactory<StudentLocalDatasource>(
    () => StudentLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory<StudentRemoteDatasource>(
    () => StudentRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerFactory<IStudentRepository>(
    () => StudentRemoteRepository(
      remoteDataSource: serviceLocator<StudentRemoteDatasource>(),
    ),
  );

  // If you want to use local repository instead, register it under the interface:
  // serviceLocator.registerFactory<IStudentRepository>(
  //   () => StudentLocalRepository(
  //     studentLocalDatasource: serviceLocator<StudentLocalDatasource>(),
  //   ),
  // );

  // Use cases (inject interface, not concrete repo)
  serviceLocator.registerFactory<StudentLoginUsecase>(
    () => StudentLoginUsecase(studentRepository: serviceLocator<IStudentRepository>()),
  );

  serviceLocator.registerFactory<StudentRegisterUsecase>(
    () => StudentRegisterUsecase(studentRepository: serviceLocator<IStudentRepository>()),
  );

  serviceLocator.registerFactory<UploadImageUsecase>(
    () => UploadImageUsecase(studentRepository: serviceLocator<IStudentRepository>()),
  );

  serviceLocator.registerFactory<StudentGetCurrentUsecase>(
    () => StudentGetCurrentUsecase(studentRepository: serviceLocator<IStudentRepository>()),
  );

  // ViewModels
  serviceLocator.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(
      serviceLocator<BatchViewModel>(),
      serviceLocator<CourseViewModel>(),
      serviceLocator<StudentRegisterUsecase>(),
      serviceLocator<UploadImageUsecase>(),
    ),
  );

  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<StudentLoginUsecase>()),
  );
}


Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
