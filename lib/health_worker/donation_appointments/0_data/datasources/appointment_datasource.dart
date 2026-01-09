import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloodconnect/donor_finder/appointments/0_data/models/appointment_model.dart';

abstract class HealthWorkerAppointmentDataSource {
  Future<List<AppointmentModel>> getAllAppointments();
}

class FirebaseHealthWorkerAppointmentDataSource
    implements HealthWorkerAppointmentDataSource {
  final FirebaseFirestore _firestore;

  FirebaseHealthWorkerAppointmentDataSource(this._firestore);

  @override
  Future<List<AppointmentModel>> getAllAppointments() async {
    try {
      final querySnapshot = await _firestore
          .collection('Appointments')
          .orderBy('appointmentDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }
}
