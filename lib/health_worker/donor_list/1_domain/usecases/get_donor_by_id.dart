import '../entities/donor_entity.dart';
import '../repositories/donor_repository.dart';

class GetDonorById {
  final DonorRepository _repository;

  GetDonorById(this._repository);

  Future<DonorEntity> call(String id) async {
    return await _repository.getDonorById(id);
  }
}