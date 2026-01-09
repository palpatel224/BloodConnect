import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/0_data/datasources/health_worker_home_remote_data_source.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/1_domain/repositories/health_worker_home_repository.dart';

class HealthWorkerHomeRepositoryImpl implements HealthWorkerHomeRepository {
  final HealthWorkerHomeRemoteDataSource _remoteDataSource;

  HealthWorkerHomeRepositoryImpl({
    required HealthWorkerHomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<BloodRequestEntity>> getPendingRequests() async {
    try {
      return await _remoteDataSource.getPendingRequests();
    } catch (e) {
      throw Exception('Failed to get pending requests: $e');
    }
  }

  @override
  Future<String> getCurrentUserName() async {
    try {
      return await _remoteDataSource.getCurrentUserName();
    } catch (e) {
      throw Exception('Failed to get current user name: $e');
    }
  }
}
