import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../1_domain/entities/blood_request_entity.dart';
import '../../../1_domain/usecases/submit_request_usecase.dart';

part 'request_screen_event.dart';
part 'request_screen_state.dart';

class RequestScreenBloc extends Bloc<RequestScreenEvent, RequestScreenState> {
  final SubmitRequestUseCase submitRequestUseCase;

  RequestScreenBloc({required this.submitRequestUseCase})
      : super(RequestScreenInitial()) {
    on<RequestScreenSubmitRequested>(_onSubmitRequested);
  }

  Future<void> _onSubmitRequested(
    RequestScreenSubmitRequested event,
    Emitter<RequestScreenState> emit,
  ) async {
    try {
      emit(RequestScreenLoading());

      // Create a new blood request entity with pending status
      final requestEntity = BloodRequestEntity(
        patientName: event.patientName,
        bloodType: event.bloodType,
        units: event.units,
        hospital: event.hospital,
        urgencyLevel: event.urgencyLevel,
        reason: event.reason,
        contactNumber: event.contactNumber,
        additionalInfo: event.additionalInfo,
        isEmergency: event.isEmergency,
        requestStatus: RequestStatus.pending,
        latitude: event.latitude,
        longitude: event.longitude,
        placeId: event.placeId,
        createdAt: DateTime.now(),
      );

      // Submit the request to Firebase
      final submittedRequest = await submitRequestUseCase(requestEntity);

      // Emit success state with the request ID
      emit(RequestScreenSuccess(submittedRequest.id!));
    } catch (e) {
      emit(RequestScreenFailure(e.toString()));
    }
  }
}
