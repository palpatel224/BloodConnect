import '../repositories/appointment_repository.dart';

class GetHomeScreenDonationEligibilityUseCase {
  final HomeScreenAppointmentRepository repository;

  GetHomeScreenDonationEligibilityUseCase(this.repository);

  Future<bool> isDonorEligible() async {
    return await repository.isDonorEligible();
  }

  Future<int> getDaysUntilEligible() async {
    return await repository.getDaysUntilEligible();
  }

  Future<String> getNextEligibleDate() async {
    return await repository.getNextEligibleDate();
  }
}
