import 'package:dartz/dartz.dart';

import '../entities/donor_info_entity.dart';
import '../failures/donor_info_failure.dart';

abstract class DonorInfoRepository {
  Future<Either<DonorInfoFailure, Unit>> saveDonorInfo(DonorInfo donorInfo);
  Future<Either<DonorInfoFailure, DonorInfo>> getDonorInfo(String userId);
  Future<Either<DonorInfoFailure, Unit>> updateDonorInfo(DonorInfo donorInfo);
  Future<Either<DonorInfoFailure, Unit>> deleteDonorInfo(String userId);
}
