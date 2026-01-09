import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../1_domain/entities/appointment_entity.dart';
import '../../1_domain/repositories/appointment_repository.dart';
import '../models/appointment_model.dart';

class HomeScreenAppointmentRepositoryImpl
    implements HomeScreenAppointmentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  HomeScreenAppointmentRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<List<HomeScreenAppointmentEntity>> getAppointments() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('Appointments')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => HomeScreenAppointmentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> isDonorEligible() async {
    try {
      final lastDonation = await _getLastCompletedDonation();
      if (lastDonation == null) return true; // No donations yet, so eligible

      final DateTime today = DateTime.now();

      // Standard waiting period is 90 days between whole blood donations
      final DateTime nextEligibleDate =
          lastDonation.add(const Duration(days: 90));

      return today.isAfter(nextEligibleDate);
    } catch (e) {
      print('Error checking donor eligibility: $e');
      return false;
    }
  }

  @override
  Future<int> getDaysUntilEligible() async {
    try {
      final lastDonation = await _getLastCompletedDonation();
      if (lastDonation == null) return 0; // No donations yet, so eligible now

      final DateTime today = DateTime.now();
      final DateTime nextEligibleDate =
          lastDonation.add(const Duration(days: 90));

      if (today.isAfter(nextEligibleDate)) {
        return 0;
      } else {
        return nextEligibleDate.difference(today).inDays;
      }
    } catch (e) {
      print('Error calculating days until eligible: $e');
      return 0;
    }
  }

  @override
  Future<String> getNextEligibleDate() async {
    try {
      final lastDonation = await _getLastCompletedDonation();
      if (lastDonation == null) {
        return DateFormat('MMMM d, y').format(DateTime.now());
      }

      final DateTime nextEligibleDate =
          lastDonation.add(const Duration(days: 90));
      return DateFormat('MMMM d, y').format(nextEligibleDate);
    } catch (e) {
      print('Error getting next eligible date: $e');
      return 'Unknown';
    }
  }

  Future<DateTime?> _getLastCompletedDonation() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final snapshot = await _firestore
          .collection('Appointments')
          .where('userId', isEqualTo: userId)
          .where('appointmentStatus', isEqualTo: 'Completed')
          .orderBy('appointmentDateTime', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final data = snapshot.docs.first.data();
      if (data['appointmentDateTime'] is Timestamp) {
        return (data['appointmentDateTime'] as Timestamp).toDate();
      }

      return null;
    } catch (e) {
      print('Error getting last donation: $e');
      return null;
    }
  }
}
