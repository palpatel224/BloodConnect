import '../../1_domain/entities/blood_request_entity.dart';
import '../../1_domain/repositories/blood_request_repository.dart';
import '../datasources/blood_request_firebase_datasource.dart';

class BloodRequestRepositoryImpl implements BloodRequestRepository {
  final BloodRequestDataSource dataSource;

  BloodRequestRepositoryImpl(this.dataSource);

  @override
  Future<BloodRequestEntity> submitRequest(BloodRequestEntity request) async {
    return await dataSource.submitRequest(request);
  }

  @override
  Future<void> updateRequestStatus(
      String requestId, RequestStatus status) async {
    await dataSource.updateRequestStatus(requestId, status);
  }

  @override
  Future<BloodRequestEntity> getRequest(String requestId) async {
    return await dataSource.getRequest(requestId);
  }

  @override
  Future<List<BloodRequestEntity>> getAllRequests() async {
    return await dataSource.getAllRequests();
  }
}
