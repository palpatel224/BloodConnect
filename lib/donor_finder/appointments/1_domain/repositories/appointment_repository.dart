import 'package:dartz/dartz.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:flutter/material.dart';

abstract class AppointmentRepository {
  Future<Either<String, String>> createAppointment(Appointment appointment);
  Future<Either<String, List<Appointment>>> getAppointmentsByUserId(
      String userId);
  Future<Either<String, Appointment>> getAppointmentById(String id);
  Future<Either<String, bool>> deleteAppointment(String id);
  Future<Either<String, bool>> updateAppointment({
    required String appointmentId,
    DateTime? appointmentDate,
    TimeOfDay? appointmentTime,
    String? status,
    String? notes,
    double? latitude,
    double? longitude,
  });
}
