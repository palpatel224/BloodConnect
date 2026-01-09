import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:dartz/dartz.dart';
import 'package:bloodconnect/core/error/failures.dart';

abstract class HealthWorkerAppointmentRepository {
  Future<List<Appointment>> getAllAppointments();

  Future<Either<Failure, List<Appointment>>> searchAppointmentsByLocation({
    required String location,
    required String placeId,
    required double radius,
  });
}
