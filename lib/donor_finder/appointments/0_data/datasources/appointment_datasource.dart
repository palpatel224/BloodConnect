import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloodconnect/donor_finder/appointments/0_data/models/appointment_model.dart';

abstract class AppointmentDataSource {
  Future<String> createAppointment(AppointmentModel appointment);
  Future<List<AppointmentModel>> getAppointmentsByUserId(String userId);
  Future<AppointmentModel> getAppointmentById(String id);
  Future<bool> deleteAppointment(String id);
  Future<bool> updateAppointment(AppointmentModel appointment);
}

class FirebaseAppointmentDataSource implements AppointmentDataSource {
  final FirebaseFirestore _firestore;

  FirebaseAppointmentDataSource(this._firestore);

  @override
  Future<String> createAppointment(AppointmentModel appointment) async {
    try {
      await _firestore
          .collection('Appointments')
          .doc(appointment.id)
          .set(appointment.toJson());

      return appointment.id;
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByUserId(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('Appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('appointmentDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }

  @override
  Future<AppointmentModel> getAppointmentById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('Appointments').doc(id).get();

      if (!docSnapshot.exists) {
        throw Exception('Appointment not found');
      }

      return AppointmentModel.fromJson(docSnapshot.data()!);
    } catch (e) {
      throw Exception('Failed to get appointment: $e');
    }
  }

  @override
  Future<bool> deleteAppointment(String id) async {
    try {
      await _firestore.collection('Appointments').doc(id).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }

  @override
  Future<bool> updateAppointment(AppointmentModel appointment) async {
    try {
      await _firestore
          .collection('Appointments')
          .doc(appointment.id)
          .update(appointment.toJson());
      return true;
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }
}
