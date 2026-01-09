import '../entities/donor_entity.dart';
import '../repositories/donor_repository.dart';

class GetDonors {
  final DonorRepository _repository;

  GetDonors(this._repository);

  Future<List<DonorEntity>> call() async {
    return await _repository.getDonors();
  }
}