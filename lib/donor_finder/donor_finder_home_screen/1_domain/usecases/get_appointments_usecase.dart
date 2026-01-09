import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetHomeScreenAppointmentsUseCase {
  final HomeScreenAppointmentRepository repository;

  GetHomeScreenAppointmentsUseCase(this.repository);

  Future<List<HomeScreenAppointmentEntity>> call() async {
    return await repository.getAppointments();
  }

  Future<List<HomeScreenAppointmentEntity>> getPendingAppointments() async {
    final appointments = await repository.getAppointments();
    return appointments
        .where((appointment) => appointment.status == 'Pending')
        .toList();
  }

  Future<List<HomeScreenAppointmentEntity>> getCompletedAppointments() async {
    final appointments = await repository.getAppointments();
    return appointments
        .where((appointment) => appointment.status == 'Completed')
        .toList();
  }
}
