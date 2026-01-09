import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/repositories/appointment_repository.dart';

class UpdateAppointment {
  final AppointmentRepository repository;

  UpdateAppointment(this.repository);

  Future<Either<String, bool>> call({
    required String appointmentId,
    DateTime? appointmentDate,
    TimeOfDay? appointmentTime,
    String? status,
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    return await repository.updateAppointment(
      appointmentId: appointmentId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      status: status,
      notes: notes,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
