part of 'health_worker_info_bloc.dart';

sealed class HealthWorkerInfoState extends Equatable {
  const HealthWorkerInfoState();

  @override
  List<Object> get props => [];
}

final class HealthWorkerInfoInitial extends HealthWorkerInfoState {}

final class HealthWorkerInfoLoading extends HealthWorkerInfoState {}

final class HealthWorkerInfoSuccess extends HealthWorkerInfoState {}

final class HealthWorkerInfoError extends HealthWorkerInfoState {
  final String message;

  const HealthWorkerInfoError(this.message);

  @override
  List<Object> get props => [message];
}
