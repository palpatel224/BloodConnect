import 'package:bloodconnect/health_worker/worker_info/1_domain/entities/worker_info_entity.dart';
import 'package:bloodconnect/health_worker/worker_info/1_domain/usecases/worker_info_failure.dart';
import 'package:dartz/dartz.dart';

abstract class WorkerInfoRepository {
  Future<Either<WorkerInfoFailure, Unit>> saveWorkerInfo(WorkerInfo workerInfo);
  Future<Either<WorkerInfoFailure, WorkerInfo>> getWorkerInfo(String userId);
  Future<Either<WorkerInfoFailure, Unit>> updateWorkerInfo(WorkerInfo workerInfo);
  Future<Either<WorkerInfoFailure, Unit>> deleteWorkerInfo(String userId);
}
