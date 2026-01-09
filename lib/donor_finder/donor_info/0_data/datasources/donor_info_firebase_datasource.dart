import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/donor_info_model.dart';

abstract class DonorInfoDataSource {
  Future<void> saveDonorInfo(DonorInfoModel donorInfo);
  Future<DonorInfoModel> getDonorInfo(String userId);
  Future<void> updateDonorInfo(DonorInfoModel donorInfo);
  Future<void> deleteDonorInfo(String userId);
}

class FirebaseDonorInfoDataSource implements DonorInfoDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseDonorInfoDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  @override
  Future<void> saveDonorInfo(DonorInfoModel donorInfo) async {
    await _firestore
        .collection('Donor_Finder')
        .doc(donorInfo.userId)
        .set(donorInfo.toJson());
  }

  @override
  Future<DonorInfoModel> getDonorInfo(String userId) async {
    final docSnapshot =
        await _firestore.collection('Donor_Finder').doc(userId).get();

    if (!docSnapshot.exists) {
      throw Exception('User information not found');
    }

    final data = docSnapshot.data() as Map<String, dynamic>;
    return DonorInfoModel.fromJson(data);
  }

  @override
  Future<void> updateDonorInfo(DonorInfoModel donorInfo) async {
    await _firestore
        .collection('Donor_Finder')
        .doc(donorInfo.userId)
        .update(donorInfo.toJson());
  }

  @override
  Future<void> deleteDonorInfo(String userId) async {
    await _firestore.collection('Donor_Finder').doc(userId).delete();
  }

  Future<String> getCurrentUserId() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }
}
