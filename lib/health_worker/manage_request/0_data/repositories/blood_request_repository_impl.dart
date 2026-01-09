import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/manage_request/0_data/datasources/blood_request_remote_data_source.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/repositories/blood_request_repository.dart';

class BloodRequestRepositoryImpl implements BloodRequestRepository {
  final BloodRequestRemoteDataSource remoteDataSource;

  BloodRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BloodRequestEntity>> getRequestsByStatus(
      RequestStatus status) async {
    try {
      return await remoteDataSource.getRequestsByStatus(status);
    } catch (e) {
      throw Exception('Failed to get requests: $e');
    }
  }

  @override
  Future<List<BloodRequestEntity>> searchRequests(String query) async {
    try {
      return await remoteDataSource.searchRequests(query);
    } catch (e) {
      throw Exception('Failed to search requests: $e');
    }
  }

  @override
  Future<void> updateRequestStatus(
      String requestId, RequestStatus newStatus) async {
    try {
      await remoteDataSource.updateRequestStatus(requestId, newStatus);
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    try {
      await remoteDataSource.deleteRequest(requestId);
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }
}
