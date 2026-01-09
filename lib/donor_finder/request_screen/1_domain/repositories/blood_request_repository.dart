import '../entities/blood_request_entity.dart';

abstract class BloodRequestRepository {
  /// Submits a new blood request to the database
  /// Returns the created request with an assigned ID
  Future<BloodRequestEntity> submitRequest(BloodRequestEntity request);

  /// Updates the status of an existing blood request
  Future<void> updateRequestStatus(String requestId, RequestStatus status);

  /// Gets a single blood request by ID
  Future<BloodRequestEntity> getRequest(String requestId);

  /// Gets all blood requests
  Future<List<BloodRequestEntity>> getAllRequests();
}
