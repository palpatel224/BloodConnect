part of 'request_screen_bloc.dart';

sealed class RequestScreenState extends Equatable {
  const RequestScreenState();

  @override
  List<Object> get props => [];
}

final class RequestScreenInitial extends RequestScreenState {}

final class RequestScreenLoading extends RequestScreenState {}

final class RequestScreenSuccess extends RequestScreenState {
  final String requestId;

  const RequestScreenSuccess(this.requestId);

  @override
  List<Object> get props => [requestId];
}

final class RequestScreenFailure extends RequestScreenState {
  final String message;

  const RequestScreenFailure(this.message);

  @override
  List<Object> get props => [message];
}
