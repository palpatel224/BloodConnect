import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donor_model.dart';

abstract class DonorDataSource {
  Future<List<DonorModel>> getDonors();
  Future<DonorModel> getDonorById(String id);
}

class FirebaseDonorDataSource implements DonorDataSource {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'Donor_Finder';

  FirebaseDonorDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<List<DonorModel>> getDonors() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection(_collectionName).get();
      return snapshot.docs.map((doc) => DonorModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get donors: ${e.toString()}');
    }
  }

  @override
  Future<DonorModel> getDonorById(String id) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection(_collectionName).doc(id).get();

      if (!snapshot.exists) {
        throw Exception('Donor not found');
      }

      return DonorModel.fromFirestore(snapshot);
    } catch (e) {
      throw Exception('Failed to get donor: ${e.toString()}');
    }
  }
}
