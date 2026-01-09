import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:bloodconnect/health_worker/donation_appointments/1_domain/repositories/appointment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:bloodconnect/core/error/failures.dart';

class SearchAppointmentsByLocationUseCase {
  final HealthWorkerAppointmentRepository repository;

  SearchAppointmentsByLocationUseCase(this.repository);

  Future<Either<Failure, List<Appointment>>> call({
    required String location,
    required String placeId,
    required double radius,
  }) async {
    return await repository.searchAppointmentsByLocation(
      location: location,
      placeId: placeId,
      radius: radius,
    );
  }
}
