import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../../../request_screen/0_data/models/blood_request_model.dart';
import '../../../request_screen/1_domain/entities/blood_request_entity.dart';
import '../../1_domain/repositories/blood_request_repository.dart';
import '../../1_domain/repositories/donor_repository.dart';
import '../../../../core/services/location_service.dart';
import '../../../../service_locator.dart';

class BloodRequestRepositoryImpl implements BloodRequestRepository {
  final FirebaseFirestore firestore;
  final DonorRepository _donorRepository;
  final LocationService _locationService;

  BloodRequestRepositoryImpl({
    required this.firestore,
    DonorRepository? donorRepository,
    LocationService? locationService,
  })  : _donorRepository = donorRepository ?? sl<DonorRepository>(),
        _locationService = locationService ?? sl<LocationService>();

  @override
  Future<Either<Failure, List<BloodRequestEntity>>> getAllRequests() async {
    try {
      final querySnapshot = await firestore.collection('Requests').get();

      final requests = querySnapshot.docs
          .map((doc) => BloodRequestModel.fromFirestore(doc))
          .toList();

      return Right(requests);
    } catch (e) {
      return Left(
          ServerFailure('Failed to load blood requests: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<BloodRequestEntity>>> searchRequests({
    required String bloodGroup,
    required String location,
    required String placeId,
    required double radius,
  }) async {
    try {
      if (location.isEmpty) {
        return Left(ServerFailure('Please specify a location'));
      }

      // Get coordinates from the placeId if provided, otherwise try to get placeId from text
      Map<String, double>? coordinates;

      if (placeId.isNotEmpty) {
        coordinates = await _locationService.getCoordinatesFromPlace(placeId);
      } else {
        // If no placeId provided, try to get one from the location text
        final newPlaceId = await _getPlaceIdFromText(location);
        if (newPlaceId != null) {
          coordinates =
              await _locationService.getCoordinatesFromPlace(newPlaceId);
        }
      }

      if (coordinates == null) {
        return Left(
            ServerFailure('Could not determine coordinates for this location'));
      }

      final latitude = coordinates['latitude']!;
      final longitude = coordinates['longitude']!;

      // Now perform the geoquery using the coordinates
      final nearbyRequests = await _donorRepository.getNearbyBloodRequests(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: radius,
        bloodGroup: bloodGroup.isEmpty ? null : bloodGroup,
      );

      return Right(nearbyRequests);
    } catch (e) {
      return Left(
          ServerFailure('Failed to search blood requests: ${e.toString()}'));
    }
  }

  // Helper method to get a placeId from location text
  // In a real implementation, this should use the Places API autocomplete or geocoding
  Future<String?> _getPlaceIdFromText(String locationText) async {
    try {
      // For implementation simplicity, returning a dummy placeId
      // This should be replaced with a proper PlacesAPI call
      return 'dummy_place_id';
    } catch (e) {
      return null;
    }
  }
}
