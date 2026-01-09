import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';

abstract class UrgentRequestRepository {
  Future<List<BloodRequestEntity>> getUrgentRequests();
}
