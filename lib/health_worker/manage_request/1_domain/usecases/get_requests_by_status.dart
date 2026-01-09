import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/repositories/blood_request_repository.dart';

class GetRequestsByStatus {
  final BloodRequestRepository repository;

  GetRequestsByStatus(this.repository);

  Future<List<BloodRequestEntity>> call(RequestStatus status) async {
    return await repository.getRequestsByStatus(status);
  }
}
