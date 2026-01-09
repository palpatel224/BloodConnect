part of 'health_worker_home_bloc.dart';

abstract class HealthWorkerHomeEvent extends Equatable {
  const HealthWorkerHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHealthWorkerHome extends HealthWorkerHomeEvent {}
