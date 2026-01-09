
part of 'manage_request_screen_bloc.dart';

abstract class ManageRequestScreenState extends Equatable {
  const ManageRequestScreenState();

  @override
  List<Object?> get props => [];
}

class ManageRequestScreenInitial extends ManageRequestScreenState {}

class ManageRequestScreenLoading extends ManageRequestScreenState {}

class ManageRequestScreenLoaded extends ManageRequestScreenState {
  final List<BloodRequestEntity> requests;
  final String currentFilter;

  const ManageRequestScreenLoaded({
    required this.requests,
    required this.currentFilter,
  });

  @override
  List<Object?> get props => [requests, currentFilter];
}

class ManageRequestScreenError extends ManageRequestScreenState {
  final String message;

  const ManageRequestScreenError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
