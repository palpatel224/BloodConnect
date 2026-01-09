import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/repositories/urgent_request_repository.dart';
import '../datasources/urgent_request_remote_datasource.dart';

class UrgentRequestRepositoryImpl implements UrgentRequestRepository {
  final UrgentRequestRemoteDataSource remoteDataSource;

  UrgentRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BloodRequestEntity>> getUrgentRequests() async {
    try {
      return await remoteDataSource.getUrgentRequests();
    } catch (e) {
      throw Exception('Failed to get urgent blood requests: $e');
    }
  }
}