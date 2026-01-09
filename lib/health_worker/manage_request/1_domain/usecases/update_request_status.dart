import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/repositories/blood_request_repository.dart';

class UpdateRequestStatus {
  final BloodRequestRepository repository;

  UpdateRequestStatus(this.repository);

  Future<void> call(String requestId, RequestStatus newStatus) async {
    return await repository.updateRequestStatus(requestId, newStatus);
  }
}
