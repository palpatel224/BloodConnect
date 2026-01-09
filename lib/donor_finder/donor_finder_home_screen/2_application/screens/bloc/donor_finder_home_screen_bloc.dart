import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/usecases/get_appointments_usecase.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/usecases/get_donation_eligibility_usecase.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/usecases/get_urgent_requests_usecase.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/widgets/appointment_card_widget.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/widgets/donation_history_card_widget.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/entities/appointment_entity.dart';
import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'donor_finder_home_screen_event.dart';
part 'donor_finder_home_screen_state.dart';

class DonorFinderHomeScreenBloc
    extends Bloc<DonorFinderHomeScreenEvent, DonorFinderHomeScreenState> {
  final GetHomeScreenAppointmentsUseCase appointmentsUseCase;
  final GetHomeScreenDonationEligibilityUseCase eligibilityUseCase;
  final GetUrgentRequestsUseCase urgentRequestsUseCase;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DonorFinderHomeScreenBloc({
    required this.appointmentsUseCase,
    required this.eligibilityUseCase,
    required this.urgentRequestsUseCase,
  }) : super(DonorFinderHomeScreenInitial()) {
    on<LoadAppointmentsEvent>(_onLoadAppointments);
    on<LoadDonationEligibilityEvent>(_onLoadDonationEligibility);
    on<LoadUrgentRequestsEvent>(_onLoadUrgentRequests);
    on<RefreshHomeScreenDataEvent>(_onRefreshData);
  }

  Future<void> _onLoadAppointments(
    LoadAppointmentsEvent event,
    Emitter<DonorFinderHomeScreenState> emit,
  ) async {
    emit(DonorFinderHomeScreenLoading());
    try {
      // Get all appointments
      final pendingAppointments =
          await appointmentsUseCase.getPendingAppointments();
      final completedAppointments =
          await appointmentsUseCase.getCompletedAppointments();

      // Get urgent requests
      final urgentRequests = await urgentRequestsUseCase.call();

      // Check eligibility
      final isEligible = await eligibilityUseCase.isDonorEligible();
      final daysUntilEligible = await eligibilityUseCase.getDaysUntilEligible();
      final nextEligibleDate = await eligibilityUseCase.getNextEligibleDate();

      // Convert domain entities to UI models
      final upcomingAppointments =
          _convertToUpcomingAppointments(pendingAppointments);
      final recentDonations = _convertToRecentDonations(completedAppointments);

      // Calculate stats
      final totalDonations = completedAppointments.length;
      final livesImpacted =
          totalDonations * 3; // Assuming each donation can help up to 3 people

      // Get user credits
      final userCredits = await _getUserCredits();

      emit(DonorFinderHomeScreenLoaded(
        upcomingAppointments: upcomingAppointments,
        recentDonations: recentDonations,
        urgentRequests: urgentRequests,
        isEligibleToDonate: isEligible,
        nextEligibleDate: nextEligibleDate,
        daysUntilEligible: daysUntilEligible,
        totalDonations: totalDonations,
        livesImpacted: livesImpacted,
        userCredits: userCredits,
      ));
    } catch (e) {
      emit(DonorFinderHomeScreenError(e.toString()));
    }
  }

  Future<void> _onLoadDonationEligibility(
    LoadDonationEligibilityEvent event,
    Emitter<DonorFinderHomeScreenState> emit,
  ) async {
    if (state is! DonorFinderHomeScreenLoaded) {
      add(LoadAppointmentsEvent());
      return;
    }

    final currentState = state as DonorFinderHomeScreenLoaded;

    try {
      final isEligible = await eligibilityUseCase.isDonorEligible();
      final daysUntilEligible = await eligibilityUseCase.getDaysUntilEligible();
      final nextEligibleDate = await eligibilityUseCase.getNextEligibleDate();

      emit(DonorFinderHomeScreenLoaded(
        upcomingAppointments: currentState.upcomingAppointments,
        recentDonations: currentState.recentDonations,
        urgentRequests: currentState.urgentRequests,
        isEligibleToDonate: isEligible,
        nextEligibleDate: nextEligibleDate,
        daysUntilEligible: daysUntilEligible,
        totalDonations: currentState.totalDonations,
        livesImpacted: currentState.livesImpacted,
        userCredits: currentState.userCredits,
      ));
    } catch (e) {
      emit(DonorFinderHomeScreenError(e.toString()));
    }
  }

  Future<void> _onLoadUrgentRequests(
    LoadUrgentRequestsEvent event,
    Emitter<DonorFinderHomeScreenState> emit,
  ) async {
    if (state is! DonorFinderHomeScreenLoaded) {
      add(LoadAppointmentsEvent());
      return;
    }

    final currentState = state as DonorFinderHomeScreenLoaded;

    try {
      final urgentRequests = await urgentRequestsUseCase.call();

      emit(DonorFinderHomeScreenLoaded(
        upcomingAppointments: currentState.upcomingAppointments,
        recentDonations: currentState.recentDonations,
        urgentRequests: urgentRequests,
        isEligibleToDonate: currentState.isEligibleToDonate,
        nextEligibleDate: currentState.nextEligibleDate,
        daysUntilEligible: currentState.daysUntilEligible,
        totalDonations: currentState.totalDonations,
        livesImpacted: currentState.livesImpacted,
        userCredits: currentState.userCredits,
      ));
    } catch (e) {
      emit(DonorFinderHomeScreenError(e.toString()));
    }
  }

  Future<void> _onRefreshData(
    RefreshHomeScreenDataEvent event,
    Emitter<DonorFinderHomeScreenState> emit,
  ) async {
    add(LoadAppointmentsEvent());
  }

  Future<int> _getUserCredits() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return 0;
      }

      final DocumentSnapshot userDoc = await _firestore
          .collection('Donor_Finder')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        return 0;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      // Handle different types (int or string) and provide a default value
      final credits = userData['credits'];
      if (credits == null) {
        return 0;
      } else if (credits is int) {
        return credits;
      } else {
        return int.tryParse(credits.toString()) ?? 0;
      }
    } catch (e) {
      print('Error fetching user credits: $e');
      return 0;
    }
  }

  List<UpcomingAppointment> _convertToUpcomingAppointments(
      List<HomeScreenAppointmentEntity> appointments) {
    return appointments
        .map((appointment) => UpcomingAppointment(
              date: appointment.date,
              time: appointment.time,
              location: appointment.location,
              distance: appointment.distance,
            ))
        .toList();
  }

  List<RecentDonation> _convertToRecentDonations(
      List<HomeScreenAppointmentEntity> appointments) {
    return appointments
        .map((appointment) => RecentDonation(
              date: appointment.date,
              location: appointment.location,
              amount: appointment.bloodAmount,
            ))
        .toList();
  }
}
