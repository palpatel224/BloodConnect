import 'package:dartz/dartz.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/repositories/appointment_repository.dart';

class CreateAppointment {
  final AppointmentRepository repository;

  CreateAppointment(this.repository);

  Future<Either<String, String>> call(Appointment appointment) async {
    return await repository.createAppointment(appointment);
  }
}
