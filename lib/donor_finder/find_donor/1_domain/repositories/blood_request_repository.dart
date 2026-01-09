import 'package:dartz/dartz.dart';
import '../../../request_screen/1_domain/entities/blood_request_entity.dart';
import '../../../../core/error/failures.dart';

abstract class BloodRequestRepository {
  Future<Either<Failure, List<BloodRequestEntity>>> getAllRequests();

  Future<Either<Failure, List<BloodRequestEntity>>> searchRequests({
    required String bloodGroup,
    required String location,
    required String placeId,
    required double radius,
  });
}
