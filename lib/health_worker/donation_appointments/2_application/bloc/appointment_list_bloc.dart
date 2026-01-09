import 'package:bloodconnect/health_worker/donation_appointments/1_domain/usecases/get_all_appointments_usecase.dart';
import 'package:bloodconnect/health_worker/donation_appointments/1_domain/usecases/search_appointments_by_location_usecase.dart';
import 'package:bloodconnect/health_worker/donation_appointments/2_application/bloc/appointment_list_event.dart';
import 'package:bloodconnect/health_worker/donation_appointments/2_application/bloc/appointment_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentListBloc
    extends Bloc<AppointmentListEvent, AppointmentListState> {
  final GetAllAppointmentsUseCase getAllAppointmentsUseCase;
  final SearchAppointmentsByLocationUseCase searchAppointmentsByLocationUseCase;

  AppointmentListBloc({
    required this.getAllAppointmentsUseCase,
    required this.searchAppointmentsByLocationUseCase,
  }) : super(const AppointmentListInitial()) {
    on<FetchAppointments>(_onFetchAppointments);
    on<LocationChanged>(_onLocationChanged);
    on<RadiusChanged>(_onRadiusChanged);
    on<SearchAppointmentsByLocation>(_onSearchAppointmentsByLocation);
    on<FilterAppointmentsByStatus>(_onFilterAppointmentsByStatus);
  }

  Future<void> _onFetchAppointments(
    FetchAppointments event,
    Emitter<AppointmentListState> emit,
  ) async {
    emit(const AppointmentListLoading());
    try {
      final appointments = await getAllAppointmentsUseCase();
      emit(AppointmentListLoaded(
        appointments: appointments,
        allAppointments: appointments,
      ));
    } catch (e) {
      emit(AppointmentListError(e.toString()));
    }
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<AppointmentListState> emit,
  ) {
    if (state is AppointmentListLoaded) {
      final currentState = state as AppointmentListLoaded;
      emit(currentState.copyWith(
        location: event.location,
      ));
    }
  }

  void _onRadiusChanged(
    RadiusChanged event,
    Emitter<AppointmentListState> emit,
  ) {
    if (state is AppointmentListLoaded) {
      final currentState = state as AppointmentListLoaded;
      emit(currentState.copyWith(radius: event.radius));
    }
  }

  void _onFilterAppointmentsByStatus(
    FilterAppointmentsByStatus event,
    Emitter<AppointmentListState> emit,
  ) {
    if (state is AppointmentListLoaded) {
      final currentState = state as AppointmentListLoaded;

      if (event.status == null) {
        // Show all appointments
        emit(currentState.copyWith(
          appointments: currentState.allAppointments,
          filterStatus: null,
        ));
      } else {
        // Filter appointments by status
        final filteredAppointments = currentState.allAppointments
            .where((appointment) =>
                appointment.status.toLowerCase() == event.status!.toLowerCase())
            .toList();

        emit(currentState.copyWith(
          appointments: filteredAppointments,
          filterStatus: event.status,
        ));
      }
    }
  }

  Future<void> _onSearchAppointmentsByLocation(
    SearchAppointmentsByLocation event,
    Emitter<AppointmentListState> emit,
  ) async {
    if (state is AppointmentListLoaded) {
      final currentState = state as AppointmentListLoaded;
      emit(const AppointmentListLoading());

      try {
        final result = await searchAppointmentsByLocationUseCase(
          location: event.location,
          placeId: event.placeId,
          radius: event.radius,
        );

        result.fold(
          (failure) => emit(AppointmentListError(failure.message)),
          (appointments) {
            // Apply any active status filter
            final filteredAppointments = currentState.filterStatus != null
                ? appointments
                    .where((appointment) =>
                        appointment.status.toLowerCase() ==
                        currentState.filterStatus!.toLowerCase())
                    .toList()
                : appointments;

            emit(AppointmentListLoaded(
              appointments: filteredAppointments,
              allAppointments: appointments,
              location: event.location,
              radius: event.radius,
              isLocationSearch: true,
              filterStatus: currentState.filterStatus,
            ));
          },
        );
      } catch (e) {
        emit(AppointmentListError('Failed to search appointments: $e'));
      }
    }
  }
}
