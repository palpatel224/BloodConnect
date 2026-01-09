import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/repositories/blood_request_repository.dart';

class SearchRequests {
  final BloodRequestRepository repository;

  SearchRequests(this.repository);

  Future<List<BloodRequestEntity>> call(String query) async {
    return await repository.searchRequests(query);
  }
}
