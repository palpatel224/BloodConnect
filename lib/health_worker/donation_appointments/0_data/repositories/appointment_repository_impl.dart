import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:bloodconnect/health_worker/donation_appointments/0_data/datasources/appointment_datasource.dart';
import 'package:bloodconnect/health_worker/donation_appointments/1_domain/repositories/appointment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:bloodconnect/core/error/failures.dart';
import 'package:bloodconnect/core/services/location_service.dart';
import 'package:bloodconnect/service_locator.dart';
import 'dart:math' as math;

class HealthWorkerAppointmentRepositoryImpl
    implements HealthWorkerAppointmentRepository {
  final HealthWorkerAppointmentDataSource dataSource;
  final LocationService _locationService;

  HealthWorkerAppointmentRepositoryImpl(
    this.dataSource, {
    LocationService? locationService,
  }) : _locationService = locationService ?? sl<LocationService>();

  @override
  Future<List<Appointment>> getAllAppointments() async {
    try {
      final appointments = await dataSource.getAllAppointments();
      return appointments;
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>> searchAppointmentsByLocation({
    required String location,
    required String placeId,
    required double radius,
  }) async {
    try {
      if (location.isEmpty) {
        return Left(ServerFailure('Please specify a location'));
      }

      // Get coordinates from the placeId
      Map<String, double>? coordinates;

      if (placeId.isNotEmpty) {
        coordinates = await _locationService.getCoordinatesFromPlace(placeId);
      }

      if (coordinates == null) {
        return Left(
            ServerFailure('Could not determine coordinates for this location'));
      }

      final latitude = coordinates['latitude']!;
      final longitude = coordinates['longitude']!;

      // Get all appointments
      final allAppointments = await dataSource.getAllAppointments();

      // Filter appointments by distance
      final List<Appointment> nearbyAppointments = [];

      for (final appointment in allAppointments) {
        if (appointment.latitude != 0 && appointment.longitude != 0) {
          // Calculate distance between the search location and the appointment location
          final double distance = _calculateDistance(
              latitude, longitude, appointment.latitude, appointment.longitude);

          // Include appointment if within the radius
          if (distance <= radius) {
            nearbyAppointments.add(appointment);
          }
        }
      }

      return Right(nearbyAppointments);
    } catch (e) {
      return Left(ServerFailure('Failed to search appointments: $e'));
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
}
