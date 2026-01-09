import 'package:dartz/dartz.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/repositories/appointment_repository.dart';

class DeleteAppointment {
  final AppointmentRepository repository;

  DeleteAppointment(this.repository);

  Future<Either<String, bool>> call(String appointmentId) async {
    return await repository.deleteAppointment(appointmentId);
  }
}
