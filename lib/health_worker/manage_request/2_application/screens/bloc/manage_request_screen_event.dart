part of 'manage_request_screen_bloc.dart';

abstract class ManageRequestScreenEvent extends Equatable {
  const ManageRequestScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadRequests extends ManageRequestScreenEvent {
  final RequestStatus status;

  const LoadRequests({required this.status});

  @override
  List<Object> get props => [status];
}

class SearchRequestsEvent extends ManageRequestScreenEvent {
  final String query;

  const SearchRequestsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class FilterRequests extends ManageRequestScreenEvent {
  final String filter;

  const FilterRequests({required this.filter});

  @override
  List<Object> get props => [filter];
}

class RefreshRequests extends ManageRequestScreenEvent {
  const RefreshRequests();
}

class UpdateRequestStatusEvent extends ManageRequestScreenEvent {
  final String requestId;
  final RequestStatus newStatus;
  final RequestStatus currentFilter;

  const UpdateRequestStatusEvent({
    required this.requestId,
    required this.newStatus,
    required this.currentFilter,
  });

  @override
  List<Object> get props => [requestId, newStatus, currentFilter];
}

class DeleteRequestEvent extends ManageRequestScreenEvent {
  final String requestId;
  final RequestStatus currentFilter;

  const DeleteRequestEvent({
    required this.requestId,
    required this.currentFilter,
  });

  @override
  List<Object> get props => [requestId, currentFilter];
}
