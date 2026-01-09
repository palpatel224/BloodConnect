part of 'donor_finder_home_screen_bloc.dart';

sealed class DonorFinderHomeScreenState extends Equatable {
  const DonorFinderHomeScreenState();

  @override
  List<Object> get props => [];
}

final class DonorFinderHomeScreenInitial extends DonorFinderHomeScreenState {}

final class DonorFinderHomeScreenLoading extends DonorFinderHomeScreenState {}

final class DonorFinderHomeScreenLoaded extends DonorFinderHomeScreenState {
  final List<UpcomingAppointment> upcomingAppointments;
  final List<RecentDonation> recentDonations;
  final List<BloodRequestEntity> urgentRequests;
  final bool isEligibleToDonate;
  final String nextEligibleDate;
  final int daysUntilEligible;
  final int totalDonations;
  final int livesImpacted;
  final int userCredits;

  const DonorFinderHomeScreenLoaded({
    required this.upcomingAppointments,
    required this.recentDonations,
    required this.urgentRequests,
    required this.isEligibleToDonate,
    required this.nextEligibleDate,
    required this.daysUntilEligible,
    required this.totalDonations,
    required this.livesImpacted,
    required this.userCredits,
  });

  @override
  List<Object> get props => [
        upcomingAppointments,
        recentDonations,
        urgentRequests,
        isEligibleToDonate,
        nextEligibleDate,
        daysUntilEligible,
        totalDonations,
        livesImpacted,
        userCredits,
      ];
}

final class DonorFinderHomeScreenError extends DonorFinderHomeScreenState {
  final String message;

  const DonorFinderHomeScreenError(this.message);

  @override
  List<Object> get props => [message];
}
