import 'package:bloodconnect/health_worker/worker_info/0_data/datasources/worker_info_firebase_datasource.dart';
import 'package:bloodconnect/health_worker/worker_info/0_data/models/worker_info_model.dart';
import 'package:bloodconnect/health_worker/worker_info/1_domain/entities/worker_info_entity.dart';
import 'package:bloodconnect/health_worker/worker_info/1_domain/repositories/worker_info_repository.dart';
import 'package:bloodconnect/health_worker/worker_info/1_domain/usecases/worker_info_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';


class WorkerInfoRepositoryImpl implements WorkerInfoRepository {
  final WorkerInfoFirebaseDatasourceImpl _dataSource;

  WorkerInfoRepositoryImpl(this._dataSource);

  @override
  Future<Either<WorkerInfoFailure, Unit>> saveWorkerInfo(
      WorkerInfo workerInfo) async {
    try {
      // Convert domain entity to data model
      final donorInfoModel = WorkerInfoModel.fromDomain(workerInfo);
      await _dataSource.saveWorkerInfo(donorInfoModel);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<WorkerInfoFailure, WorkerInfo>> getWorkerInfo(
      String userId) async {
    try {
      final workerInfoModel = await _dataSource.getWorkerInfo(userId);
      return right(workerInfoModel);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<WorkerInfoFailure, Unit>> updateWorkerInfo(
      WorkerInfo workerInfo) async {
    try {
      final workerInfoModel = WorkerInfoModel.fromDomain(workerInfo);
      await _dataSource.updateWorkerInfo(workerInfoModel);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<WorkerInfoFailure, Unit>> deleteWorkerInfo(String userId) async {
    try {
      await _dataSource.deleteWorkerInfo(userId);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}
