import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloodconnect/health_worker/worker_info/1_domain/repositories/worker_info_repository.dart';
import 'package:bloodconnect/health_worker/worker_info/1_domain/entities/worker_info_entity.dart';
import 'package:bloodconnect/core/services/places_service/places_api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'health_worker_info_event.dart';
part 'health_worker_info_state.dart';

class HealthWorkerInfoBloc
    extends Bloc<HealthWorkerInfoEvent, HealthWorkerInfoState> {
  final WorkerInfoRepository _repository;
  final FirebaseAuth _auth;
  final PlacesApiService _placesService;

  HealthWorkerInfoBloc({
    required WorkerInfoRepository repository,
    required FirebaseAuth auth,
    required PlacesApiService placesService,
  })  : _repository = repository,
        _auth = auth,
        _placesService = placesService,
        super(HealthWorkerInfoInitial()) {
    on<SubmitHealthWorkerInfo>(_onSubmitHealthWorkerInfo);
  }

  Future<void> _onSubmitHealthWorkerInfo(
    SubmitHealthWorkerInfo event,
    Emitter<HealthWorkerInfoState> emit,
  ) async {
    try {
      emit(HealthWorkerInfoLoading());

      // Get current user ID from Firebase Auth
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Update user display name
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(event.name);
      }

      // Create worker info entity with data from the event
      final workerInfo = WorkerInfo(
        id: userId,
        name: event.name,
        profession: event.profession,
        location: event.location,
        institutionName: event.institution,
        latitude: event.latitude,
        longitude: event.longitude,
        placeId: event.placeId,
      );

      // Save worker info to the database using the repository
      final result = await _repository.saveWorkerInfo(workerInfo);

      result.fold(
        (failure) => emit(HealthWorkerInfoError(failure.message)),
        (_) => emit(HealthWorkerInfoSuccess()),
      );
    } catch (error) {
      emit(HealthWorkerInfoError(error.toString()));
    }
  }
}
