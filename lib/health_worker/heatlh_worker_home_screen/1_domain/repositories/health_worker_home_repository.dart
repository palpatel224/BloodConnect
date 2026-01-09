import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';

abstract class HealthWorkerHomeRepository {
  Future<List<BloodRequestEntity>> getPendingRequests();
  Future<String> getCurrentUserName();
}
