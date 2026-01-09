import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blood_request_model.dart';
import '../../1_domain/entities/blood_request_entity.dart';

abstract class BloodRequestDataSource {
  Future<BloodRequestModel> submitRequest(BloodRequestEntity request);
  Future<void> updateRequestStatus(String requestId, RequestStatus status);
  Future<BloodRequestModel> getRequest(String requestId);
  Future<List<BloodRequestModel>> getAllRequests();
}

class BloodRequestFirebaseDataSource implements BloodRequestDataSource {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'Requests';

  BloodRequestFirebaseDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<BloodRequestModel> submitRequest(BloodRequestEntity request) async {
    final model = BloodRequestModel.fromEntity(request);
    final docRef =
        await _firestore.collection(_collectionName).add(model.toMap());

    // Fetch the created document to return with the ID
    final docSnapshot = await docRef.get();
    return BloodRequestModel.fromFirestore(docSnapshot);
  }

  @override
  Future<void> updateRequestStatus(
      String requestId, RequestStatus status) async {
    await _firestore.collection(_collectionName).doc(requestId).update({
      'requestStatus': status.name,
    });
  }

  @override
  Future<BloodRequestModel> getRequest(String requestId) async {
    final docSnapshot =
        await _firestore.collection(_collectionName).doc(requestId).get();
    if (!docSnapshot.exists) {
      throw Exception('Request not found');
    }
    return BloodRequestModel.fromFirestore(docSnapshot);
  }

  @override
  Future<List<BloodRequestModel>> getAllRequests() async {
    final querySnapshot = await _firestore.collection(_collectionName).get();
    return querySnapshot.docs
        .map((doc) => BloodRequestModel.fromFirestore(doc))
        .toList();
  }
}
