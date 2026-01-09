import 'package:bloodconnect/health_worker/manage_request/1_domain/repositories/blood_request_repository.dart';

class DeleteRequest {
  final BloodRequestRepository repository;

  DeleteRequest(this.repository);

  Future<void> call(String requestId) async {
    return await repository.deleteRequest(requestId);
  }
}
