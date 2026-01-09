import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/usecases/delete_request.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/usecases/get_requests_by_status.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/usecases/search_requests.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/usecases/update_request_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'manage_request_screen_event.dart';
part 'manage_request_screen_state.dart';

// Bloc
class ManageRequestScreenBloc
    extends Bloc<ManageRequestScreenEvent, ManageRequestScreenState> {
  final GetRequestsByStatus getRequestsByStatus;
  final SearchRequests searchRequests;
  final UpdateRequestStatus updateRequestStatus;
  final DeleteRequest deleteRequest;

  ManageRequestScreenBloc({
    required this.getRequestsByStatus,
    required this.searchRequests,
    required this.updateRequestStatus,
    required this.deleteRequest,
  }) : super(ManageRequestScreenInitial()) {
    on<LoadRequests>(_onLoadRequests);
    on<SearchRequestsEvent>(_onSearchRequests);
    on<UpdateRequestStatusEvent>(_onUpdateRequestStatus);
    on<DeleteRequestEvent>(_onDeleteRequest);
  }

  Future<void> _onLoadRequests(
    LoadRequests event,
    Emitter<ManageRequestScreenState> emit,
  ) async {
    emit(ManageRequestScreenLoading());
    try {
      final requests = await getRequestsByStatus(event.status);
      emit(ManageRequestScreenLoaded(
          requests: requests, currentFilter: event.status.toString()));
    } catch (e) {
      emit(ManageRequestScreenError(message: e.toString()));
    }
  }

  Future<void> _onSearchRequests(
    SearchRequestsEvent event,
    Emitter<ManageRequestScreenState> emit,
  ) async {
    emit(ManageRequestScreenLoading());
    try {
      final requests = await searchRequests(event.query);
      emit(ManageRequestScreenLoaded(
          requests: requests, currentFilter: 'search'));
    } catch (e) {
      emit(ManageRequestScreenError(message: e.toString()));
    }
  }

  Future<void> _onUpdateRequestStatus(
    UpdateRequestStatusEvent event,
    Emitter<ManageRequestScreenState> emit,
  ) async {
    try {
      // First update the request status in Firebase
      await updateRequestStatus(event.requestId, event.newStatus);

      // Then reload requests to reflect the changes
      final requests = await getRequestsByStatus(event.currentFilter);
      emit(ManageRequestScreenLoaded(
          requests: requests, currentFilter: event.currentFilter.toString()));
    } catch (e) {
      emit(ManageRequestScreenError(message: e.toString()));
    }
  }

  Future<void> _onDeleteRequest(
    DeleteRequestEvent event,
    Emitter<ManageRequestScreenState> emit,
  ) async {
    try {
      // Delete the request from Firebase
      await deleteRequest(event.requestId);

      // Then reload requests to reflect the changes
      final requests = await getRequestsByStatus(event.currentFilter);
      emit(ManageRequestScreenLoaded(
          requests: requests, currentFilter: event.currentFilter.toString()));
    } catch (e) {
      emit(ManageRequestScreenError(message: e.toString()));
    }
  }
}
