part of 'donor_finder_home_screen_bloc.dart';

sealed class DonorFinderHomeScreenEvent extends Equatable {
  const DonorFinderHomeScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadAppointmentsEvent extends DonorFinderHomeScreenEvent {}

class LoadDonationEligibilityEvent extends DonorFinderHomeScreenEvent {}

class LoadUrgentRequestsEvent extends DonorFinderHomeScreenEvent {}

class RefreshHomeScreenDataEvent extends DonorFinderHomeScreenEvent {}
