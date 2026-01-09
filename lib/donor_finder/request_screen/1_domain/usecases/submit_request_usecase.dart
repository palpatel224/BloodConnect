import '../entities/blood_request_entity.dart';
import '../repositories/blood_request_repository.dart';

class SubmitRequestUseCase {
  final BloodRequestRepository repository;

  SubmitRequestUseCase(this.repository);

  Future<BloodRequestEntity> call(BloodRequestEntity request) async {
    return await repository.submitRequest(request);
  }
}
