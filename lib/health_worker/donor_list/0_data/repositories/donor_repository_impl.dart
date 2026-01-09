import 'package:bloodconnect/health_worker/donor_list/1_domain/entities/donor_entity.dart';

import '../../1_domain/repositories/donor_repository.dart';
import '../datasources/donor_datasource.dart';

class DonorRepositoryImpl implements DonorRepository {
  final DonorDataSource _dataSource;

  DonorRepositoryImpl(this._dataSource);

  @override
  Future<List<DonorEntity>> getDonors() async {
    try {
      return await _dataSource.getDonors();
    } catch (e) {
      throw Exception('Failed to get donors: ${e.toString()}');
    }
  }

  @override
  Future<DonorEntity> getDonorById(String id) async {
    try {
      return await _dataSource.getDonorById(id);
    } catch (e) {
      throw Exception('Failed to get donor: ${e.toString()}');
    }
  }
}
