import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/1_domain/repositories/health_worker_home_repository.dart';

class GetPendingRequests {
  final HealthWorkerHomeRepository repository;

  GetPendingRequests(this.repository);

  Future<List<BloodRequestEntity>> call() async {
    return await repository.getPendingRequests();
  }
}
