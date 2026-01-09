part of 'health_worker_home_bloc.dart';

abstract class HealthWorkerHomeState extends Equatable {
  const HealthWorkerHomeState();

  @override
  List<Object> get props => [];
}

class HealthWorkerHomeInitial extends HealthWorkerHomeState {}

class HealthWorkerHomeLoading extends HealthWorkerHomeState {}

class HealthWorkerHomeLoaded extends HealthWorkerHomeState {
  final List<BloodRequestEntity> requests;
  final String userName;

  const HealthWorkerHomeLoaded({
    required this.requests,
    required this.userName,
  });

  @override
  List<Object> get props => [requests, userName];
}

class HealthWorkerHomeError extends HealthWorkerHomeState {
  final String message;

  const HealthWorkerHomeError({required this.message});

  @override
  List<Object> get props => [message];
}
