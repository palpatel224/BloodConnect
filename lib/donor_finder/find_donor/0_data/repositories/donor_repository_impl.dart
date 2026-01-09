import 'package:cloud_firestore/cloud_firestore.dart';
import '../../1_domain/repositories/donor_repository.dart';
import '../../../../donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'dart:math' as math;

class DonorRepositoryImpl implements DonorRepository {
  final FirebaseFirestore _firestore;

  DonorRepositoryImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<BloodRequestEntity>> getNearbyBloodRequests({
    required double latitude,
    required double longitude,
    required double radiusInKm,
    String? bloodGroup,
  }) async {
    try {
      // Convert radius from km to degrees latitude/longitude
      // Approximate conversion (1 degree of latitude = 111.32 km)
      final double radiusInDegrees = radiusInKm / 111.32;

      // Calculate the bounding box
      final double minLat = latitude - radiusInDegrees;
      final double maxLat = latitude + radiusInDegrees;

      // Longitude degrees per km varies by latitude
      final double radiusLongitudeDegrees =
          radiusInDegrees / math.cos(latitude * (math.pi / 180));
      final double minLng = longitude - radiusLongitudeDegrees;
      final double maxLng = longitude + radiusLongitudeDegrees;

      // Start with the base query
      Query query = _firestore
          .collection('Requests')
          .where('latitude', isGreaterThanOrEqualTo: minLat)
          .where('latitude', isLessThanOrEqualTo: maxLat);

      // If blood group is specified, add it as a filter
      if (bloodGroup != null && bloodGroup.isNotEmpty) {
        query = query.where('bloodType', isEqualTo: bloodGroup);
      }

      // Execute the first query
      final querySnapshot = await query.get();

      // Filter results further by longitude (since we can only have range filters on one field)
      // and calculate actual distance
      final List<BloodRequestEntity> nearbyRequests = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Check if longitude is within range
        final double docLongitude = data['longitude'] as double;
        if (docLongitude >= minLng && docLongitude <= maxLng) {
          // Calculate actual distance
          final double distance = _calculateDistance(
              latitude, longitude, data['latitude'] as double, docLongitude);

          // Only include if within the actual radius
          if (distance <= radiusInKm) {
            nearbyRequests.add(_mapToEntity(doc.id, data));
          }
        }
      }

      return nearbyRequests;
    } catch (e) {
      throw Exception('Failed to fetch nearby requests: $e');
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    // Haversine formula to calculate distance between two points on Earth
    const double earthRadius = 6371; // in kilometers

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  BloodRequestEntity _mapToEntity(String id, Map<String, dynamic> data) {
    return BloodRequestEntity(
      id: id,
      patientName: data['patientName'] as String,
      bloodType: data['bloodType'] as String,
      units: data['units'] as int,
      hospital: data['hospital'] as String,
      urgencyLevel: data['urgencyLevel'] as String,
      reason: data['reason'] as String,
      contactNumber: data['contactNumber'] as String,
      additionalInfo: data['additionalInfo'] as String? ?? '',
      isEmergency: data['isEmergency'] as bool? ?? false,
      requestStatus: _mapRequestStatus(data['requestStatus']),
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      placeId: data['placeId'] as String?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  RequestStatus _mapRequestStatus(dynamic status) {
    if (status is String) {
      return RequestStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => RequestStatus.pending,
      );
    }
    return RequestStatus.pending;
  }
}
