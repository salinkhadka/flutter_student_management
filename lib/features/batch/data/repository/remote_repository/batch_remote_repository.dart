import 'package:dartz/dartz.dart';
import 'package:student_management/core/error/failure.dart';
import 'package:student_management/features/batch/data/data_source/remote_datasource/batch_remote_data_source.dart';
import 'package:student_management/features/batch/domain/entity/batch_entity.dart';
import 'package:student_management/features/batch/domain/repository/batch_repository.dart';

class BatchRemoteRepository implements IBatchRepository{
  final BatchRemoteDataSource remoteDataSource;

  BatchRemoteRepository({required this.remoteDataSource});


  @override
Future<Either<Failure, void>> addBatch(BatchEntity batch) async {
  try {
    await remoteDataSource.addBatch(batch); // Await added
    return Right(null);
  } catch (e) {
    return Left(RemoteDatabaseFailure(message: e.toString()));
  }
}

  @override
  Future<Either<Failure, void>> deleteBatch(String batchId) async {
    try {
      await remoteDataSource.deleteBatch(batchId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

 @override
  Future<Either<Failure, List<BatchEntity>>> getBatches() async {
    try {
      final batches = await remoteDataSource.getBatches();
      return Right(batches);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  
}