import 'package:dartz/dartz.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/repositories/appointment_repository.dart';

class GetAppointmentsByUserId {
  final AppointmentRepository repository;

  GetAppointmentsByUserId(this.repository);

  Future<Either<String, List<Appointment>>> call(String userId) async {
    return await repository.getAppointmentsByUserId(userId);
  }
}