import '../../../../donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';

abstract class DonorRepository {
  Future<List<BloodRequestEntity>> getNearbyBloodRequests({
    required double latitude,
    required double longitude,
    required double radiusInKm,
    String? bloodGroup,
  });
}
