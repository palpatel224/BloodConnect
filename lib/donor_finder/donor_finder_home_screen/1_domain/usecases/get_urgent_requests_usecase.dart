import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import '../repositories/urgent_request_repository.dart';

class GetUrgentRequestsUseCase {
  final UrgentRequestRepository repository;

  GetUrgentRequestsUseCase(this.repository);

  Future<List<BloodRequestEntity>> call() async {
    return await repository.getUrgentRequests();
  }
}
