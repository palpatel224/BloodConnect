import '../entities/appointment_entity.dart';

abstract class HomeScreenAppointmentRepository {
  Future<List<HomeScreenAppointmentEntity>> getAppointments();
  Future<bool> isDonorEligible();
  Future<int> getDaysUntilEligible();
  Future<String> getNextEligibleDate();
}
