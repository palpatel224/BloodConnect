import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../1_domain/entities/donor_info_entity.dart';
import '../../1_domain/failures/donor_info_failure.dart';
import '../../1_domain/repositories/donor_info_repository.dart';
import '../datasources/donor_info_firebase_datasource.dart';
import '../models/donor_info_model.dart';

class DonorInfoRepositoryImpl implements DonorInfoRepository {
  final DonorInfoDataSource _dataSource;

  DonorInfoRepositoryImpl(this._dataSource);

  @override
  Future<Either<DonorInfoFailure, Unit>> saveDonorInfo(
      DonorInfo donorInfo) async {
    try {
      // Validate age (must be at least 18 years old)
      final today = DateTime.now();
      final age = today.year -
          donorInfo.dateOfBirth.year -
          (today.month < donorInfo.dateOfBirth.month ||
                  (today.month == donorInfo.dateOfBirth.month &&
                      today.day < donorInfo.dateOfBirth.day)
              ? 1
              : 0);

      if (age < 18) {
        return left(const ValidationFailure(
            'You must be at least 18 years old to register'));
      }

      // Validate blood type
      final validBloodTypes = [
        'A+',
        'A-',
        'B+',
        'B-',
        'AB+',
        'AB-',
        'O+',
        'O-'
      ];
      if (!validBloodTypes.contains(donorInfo.bloodType)) {
        return left(const ValidationFailure('Invalid blood type'));
      }

      // Convert domain entity to data model
      final donorInfoModel = DonorInfoModel.fromDomain(donorInfo);

      // Save to Firebase
      await _dataSource.saveDonorInfo(donorInfoModel);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<DonorInfoFailure, DonorInfo>> getDonorInfo(
      String userId) async {
    try {
      final donorInfoModel = await _dataSource.getDonorInfo(userId);
      return right(donorInfoModel);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<DonorInfoFailure, Unit>> updateDonorInfo(
      DonorInfo donorInfo) async {
    try {
      // Validate age (must be at least 18 years old)
      final today = DateTime.now();
      final age = today.year -
          donorInfo.dateOfBirth.year -
          (today.month < donorInfo.dateOfBirth.month ||
                  (today.month == donorInfo.dateOfBirth.month &&
                      today.day < donorInfo.dateOfBirth.day)
              ? 1
              : 0);

      if (age < 18) {
        return left(const ValidationFailure(
            'You must be at least 18 years old to register'));
      }

      // Validate blood type
      final validBloodTypes = [
        'A+',
        'A-',
        'B+',
        'B-',
        'AB+',
        'AB-',
        'O+',
        'O-'
      ];
      if (!validBloodTypes.contains(donorInfo.bloodType)) {
        return left(const ValidationFailure('Invalid blood type'));
      }

      final donorInfoModel = DonorInfoModel.fromDomain(donorInfo);
      await _dataSource.updateDonorInfo(donorInfoModel);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<DonorInfoFailure, Unit>> deleteDonorInfo(String userId) async {
    try {
      await _dataSource.deleteDonorInfo(userId);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}
