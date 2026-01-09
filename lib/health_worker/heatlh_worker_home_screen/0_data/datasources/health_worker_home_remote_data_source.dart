import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class HealthWorkerHomeRemoteDataSource {
  Future<List<BloodRequestEntity>> getPendingRequests();
  Future<String> getCurrentUserName();
}

class HealthWorkerHomeRemoteDataSourceImpl
    implements HealthWorkerHomeRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  HealthWorkerHomeRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  @override
  Future<List<BloodRequestEntity>> getPendingRequests() async {
    try {
      final querySnapshot = await _firestore
          .collection('Requests')
          .where('requestStatus', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return BloodRequestEntity(
          id: doc.id,
          patientName: data['patientName'] ?? '',
          bloodType: data['bloodType'] ?? '',
          units: data['units'] ?? 0,
          hospital: data['hospital'] ?? '',
          urgencyLevel: data['urgencyLevel'] ?? '',
          reason: data['reason'] ?? '',
          contactNumber: data['contactNumber'] ?? '',
          additionalInfo: data['additionalInfo'] ?? '',
          isEmergency: data['isEmergency'] ?? false,
          requestStatus: RequestStatus.pending,
          latitude: data['latitude']?.toDouble(),
          longitude: data['longitude']?.toDouble(),
          placeId: data['placeId'],
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch pending requests: $e');
    }
  }

  @override
  Future<String> getCurrentUserName() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      return user.displayName ?? 'Health Worker';
    } catch (e) {
      throw Exception('Failed to get user name: $e');
    }
  }
}
