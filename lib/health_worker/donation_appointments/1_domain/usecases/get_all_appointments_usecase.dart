import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:bloodconnect/health_worker/donation_appointments/1_domain/repositories/appointment_repository.dart';

class GetAllAppointmentsUseCase {
  final HealthWorkerAppointmentRepository repository;

  GetAllAppointmentsUseCase(this.repository);

  Future<List<Appointment>> call() async {
    return await repository.getAllAppointments();
  }
}
