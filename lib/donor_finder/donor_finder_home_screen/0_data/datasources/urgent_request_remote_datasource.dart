import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';

abstract class UrgentRequestRemoteDataSource {
  Future<List<BloodRequestEntity>> getUrgentRequests();
}

class UrgentRequestRemoteDataSourceImpl
    implements UrgentRequestRemoteDataSource {
  final FirebaseFirestore firestore;
  final int limit;

  UrgentRequestRemoteDataSourceImpl({
    required this.firestore,
    this.limit = 5,
  });

  @override
  Future<List<BloodRequestEntity>> getUrgentRequests() async {
    try {
      // First fetch all emergency requests regardless of status
      final emergencyQuerySnapshot = await firestore
          .collection('Requests')
          .where('isEmergency', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      // If we have enough emergency requests, return them
      if (emergencyQuerySnapshot.docs.length >= limit) {
        return _convertToBloodRequestEntities(emergencyQuerySnapshot.docs);
      }

      // Otherwise, fetch additional non-emergency approved requests to fill the limit
      final remainingLimit = limit - emergencyQuerySnapshot.docs.length;
      final regularQuerySnapshot = await firestore
          .collection('Requests')
          .where('isEmergency', isEqualTo: false)
          .where('requestStatus',
              isEqualTo: RequestStatus.approved.toString().split('.').last)
          .orderBy('urgencyLevel', descending: true)
          .orderBy('createdAt', descending: true)
          .limit(remainingLimit)
          .get();

      // Combine both results
      final allDocs = [
        ...emergencyQuerySnapshot.docs,
        ...regularQuerySnapshot.docs
      ];

      return _convertToBloodRequestEntities(allDocs);
    } catch (e) {
      throw Exception('Failed to fetch urgent requests: $e');
    }
  }

  List<BloodRequestEntity> _convertToBloodRequestEntities(
      List<QueryDocumentSnapshot> docs) {
    return docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
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
  }
}
