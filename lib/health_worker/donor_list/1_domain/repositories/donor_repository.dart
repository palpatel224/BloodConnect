import '../entities/donor_entity.dart';

abstract class DonorRepository {
  Future<List<DonorEntity>> getDonors();
  Future<DonorEntity> getDonorById(String id);
}