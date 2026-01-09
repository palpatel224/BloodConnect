import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';

abstract class BloodRequestRemoteDataSource {
  Future<List<BloodRequestEntity>> getRequestsByStatus(RequestStatus status);
  Future<List<BloodRequestEntity>> searchRequests(String query);
  Future<void> updateRequestStatus(String requestId, RequestStatus newStatus);
  Future<void> deleteRequest(String requestId);
}

class BloodRequestRemoteDataSourceImpl implements BloodRequestRemoteDataSource {
  final FirebaseFirestore firestore;

  BloodRequestRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<BloodRequestEntity>> getRequestsByStatus(
      RequestStatus status) async {
    try {
      final querySnapshot = await firestore
          .collection('Requests')
          .where('requestStatus', isEqualTo: status.toString().split('.').last)
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
          requestStatus: RequestStatus.values.firstWhere(
            (e) => e.toString().split('.').last == data['requestStatus'],
            orElse: () => RequestStatus.pending,
          ),
          latitude: data['latitude']?.toDouble(),
          longitude: data['longitude']?.toDouble(),
          placeId: data['placeId'],
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch requests: $e');
    }
  }

  @override
  Future<List<BloodRequestEntity>> searchRequests(String query) async {
    try {
      final querySnapshot = await firestore
          .collection('Requests')
          .where('patientName', isGreaterThanOrEqualTo: query)
          .where('patientName', isLessThanOrEqualTo: '$query\uf8ff')
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
          requestStatus: RequestStatus.values.firstWhere(
            (e) => e.toString().split('.').last == data['requestStatus'],
            orElse: () => RequestStatus.pending,
          ),
          latitude: data['latitude']?.toDouble(),
          longitude: data['longitude']?.toDouble(),
          placeId: data['placeId'],
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search requests: $e');
    }
  }

  @override
  Future<void> updateRequestStatus(
      String requestId, RequestStatus newStatus) async {
    try {
      await firestore.collection('Requests').doc(requestId).update({
        'requestStatus': newStatus.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    try {
      await firestore.collection('Requests').doc(requestId).delete();
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }
}
