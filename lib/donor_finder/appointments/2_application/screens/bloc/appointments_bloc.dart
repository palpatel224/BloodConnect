import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/usecases/create_appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/usecases/delete_appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/usecases/get_appointments.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/usecases/update_appointment.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final CreateAppointment createAppointmentUseCase;
  final GetAppointmentsByUserId getAppointmentsByUserIdUseCase;
  final DeleteAppointment deleteAppointmentUseCase;
  final UpdateAppointment updateAppointmentUseCase;
  final FirebaseAuth firebaseAuth;
  final uuid = const Uuid();

  AppointmentsBloc({
    required this.createAppointmentUseCase,
    required this.getAppointmentsByUserIdUseCase,
    required this.firebaseAuth,
    required this.deleteAppointmentUseCase,
    required this.updateAppointmentUseCase,
  }) : super(AppointmentsInitial()) {
    on<CreateAppointmentEvent>(_onCreateAppointment);
    on<GetUserAppointmentsEvent>(_onGetUserAppointments);
    on<GetSingleAppointmentEvent>(_onGetSingleAppointment);
    on<DeleteAppointmentEvent>(_onDeleteAppointment);
    on<UpdateAppointmentEvent>(_onUpdateAppointment);
  }

  Future<void> _onCreateAppointment(
    CreateAppointmentEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());

    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        emit(const AppointmentCreationFailed(
          message: 'User is not authenticated',
        ));
        return;
      }

      final appointmentId = uuid.v4();
      final formattedTime = _formatTimeOfDay(event.appointmentTime);

      final appointment = Appointment(
        id: appointmentId,
        userId: currentUser.uid,
        donorId: event.donorId,
        name: event.name,
        bloodType: event.bloodType,
        phoneNumber: event.phoneNumber,
        appointmentDate: event.appointmentDate,
        appointmentTime: formattedTime,
        hospital: event.hospital,
        notes: event.notes,
        createdAt: DateTime.now(),
        status: event.status,
        latitude: event.latitude,
        longitude: event.longitude,
      );

      final result = await createAppointmentUseCase(appointment);

      result.fold(
        (failure) => emit(AppointmentCreationFailed(message: failure)),
        (appointmentId) =>
            emit(AppointmentCreated(appointmentId: appointmentId)),
      );
    } catch (e) {
      emit(AppointmentCreationFailed(message: e.toString()));
    }
  }

  Future<void> _onGetUserAppointments(
    GetUserAppointmentsEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());

    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        emit(const AppointmentsError(message: 'User is not authenticated'));
        return;
      }

      final userId = event.userId.isNotEmpty ? event.userId : currentUser.uid;
      final result = await getAppointmentsByUserIdUseCase(userId);

      result.fold(
        (failure) => emit(AppointmentsError(message: failure)),
        (appointments) => emit(AppointmentsLoaded(appointments: appointments)),
      );
    } catch (e) {
      emit(AppointmentsError(message: e.toString()));
    }
  }

  Future<void> _onGetSingleAppointment(
    GetSingleAppointmentEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());
    // Will be implemented as needed
  }

  Future<void> _onUpdateAppointment(
    UpdateAppointmentEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());

    try {
      final result = await updateAppointmentUseCase(
        appointmentId: event.appointmentId,
        appointmentDate: event.appointmentDate,
        appointmentTime: event.appointmentTime,
        status: event.status,
        notes: event.notes,
        latitude: event.latitude,
        longitude: event.longitude,
      );

      result.fold(
        (failure) => emit(AppointmentsError(message: failure)),
        (_) => emit(AppointmentUpdated(appointmentId: event.appointmentId)),
      );
    } catch (e) {
      emit(AppointmentsError(message: e.toString()));
    }
  }

  Future<void> _onDeleteAppointment(
    DeleteAppointmentEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());

    try {
      final result = await deleteAppointmentUseCase(event.appointmentId);

      result.fold(
        (failure) => emit(AppointmentsError(message: failure)),
        (_) => emit(AppointmentDeleted(appointmentId: event.appointmentId)),
      );
    } catch (e) {
      emit(AppointmentsError(message: e.toString()));
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('h:mm a').format(dt);
  }
}
