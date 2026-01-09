import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/1_domain/usecases/get_current_user_name.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/1_domain/usecases/get_pending_requests.dart';

part 'health_worker_home_event.dart';
part 'health_worker_home_state.dart';

class HealthWorkerHomeBloc
    extends Bloc<HealthWorkerHomeEvent, HealthWorkerHomeState> {
  final GetPendingRequests _getPendingRequests;
  final GetCurrentUserName _getCurrentUserName;

  HealthWorkerHomeBloc({
    required GetPendingRequests getPendingRequests,
    required GetCurrentUserName getCurrentUserName,
  })  : _getPendingRequests = getPendingRequests,
        _getCurrentUserName = getCurrentUserName,
        super(HealthWorkerHomeInitial()) {
    on<LoadHealthWorkerHome>(_onLoadHealthWorkerHome);
  }

  Future<void> _onLoadHealthWorkerHome(
    LoadHealthWorkerHome event,
    Emitter<HealthWorkerHomeState> emit,
  ) async {
    emit(HealthWorkerHomeLoading());
    try {
      final requests = await _getPendingRequests();
      final userName = await _getCurrentUserName();
      emit(HealthWorkerHomeLoaded(
        requests: requests,
        userName: userName,
      ));
    } catch (e) {
      emit(HealthWorkerHomeError(message: e.toString()));
    }
  }
}
