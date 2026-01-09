import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../1_domain/repositories/blood_request_repository.dart';
import '../../../../request_screen/1_domain/entities/blood_request_entity.dart';

part 'find_request_event.dart';
part 'find_request_state.dart';

class FindRequestBloc extends Bloc<FindRequestEvent, FindRequestState> {
  final BloodRequestRepository requestRepository;

  FindRequestBloc({required this.requestRepository})
      : super(FindRequestInitial()) {
    on<LoadRequests>(_onLoadRequests);
    on<BloodGroupChanged>(_onBloodGroupChanged);
    on<LocationChanged>(_onLocationChanged);
    on<RadiusChanged>(_onRadiusChanged);
    on<SearchRequests>(_onSearchRequests);
  }

  void _onLoadRequests(
      LoadRequests event, Emitter<FindRequestState> emit) async {
    emit(FindRequestLoading());
    try {
      final result = await requestRepository.getAllRequests();

      result.fold(
        (failure) => emit(FindRequestError(failure.toString())),
        (requests) => emit(FindRequestLoaded(requests: requests)),
      );
    } catch (e) {
      emit(FindRequestError('Failed to load requests: ${e.toString()}'));
    }
  }

  void _onBloodGroupChanged(
      BloodGroupChanged event, Emitter<FindRequestState> emit) {
    if (state is FindRequestLoaded) {
      final currentState = state as FindRequestLoaded;
      emit(currentState.copyWith(selectedBloodGroup: event.bloodGroup));
    }
  }

  void _onLocationChanged(
      LocationChanged event, Emitter<FindRequestState> emit) {
    if (state is FindRequestLoaded) {
      final currentState = state as FindRequestLoaded;
      emit(currentState.copyWith(
        location: event.location,
        placeId: event.placeId,
      ));
    }
  }

  void _onRadiusChanged(RadiusChanged event, Emitter<FindRequestState> emit) {
    if (state is FindRequestLoaded) {
      final currentState = state as FindRequestLoaded;
      emit(currentState.copyWith(radius: event.radius));
    }
  }

  void _onSearchRequests(
      SearchRequests event, Emitter<FindRequestState> emit) async {
    emit(FindRequestLoading());

    try {
      String bloodGroup = event.bloodGroup;
      String location = event.location;
      String placeId = event.placeId;
      double radius = event.radius;

      final result = await requestRepository.searchRequests(
        bloodGroup: bloodGroup,
        location: location,
        placeId: placeId,
        radius: radius,
      );

      result.fold(
        (failure) => emit(FindRequestError(failure.toString())),
        (requests) => emit(FindRequestLoaded(
          requests: requests,
          selectedBloodGroup: bloodGroup,
          location: location,
          placeId: placeId,
          radius: radius,
        )),
      );
    } catch (e) {
      emit(FindRequestError('Failed to search requests: ${e.toString()}'));
    }
  }
}
