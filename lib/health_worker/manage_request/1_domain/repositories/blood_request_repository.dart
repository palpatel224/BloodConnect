import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';

abstract class BloodRequestRepository {
  Future<List<BloodRequestEntity>> getRequestsByStatus(RequestStatus status);
  Future<List<BloodRequestEntity>> searchRequests(String query);
  Future<void> updateRequestStatus(String requestId, RequestStatus newStatus);
  Future<void> deleteRequest(String requestId);
}
