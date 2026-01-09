import 'package:bloodconnect/donor_finder/appointments/0_data/datasources/appointment_datasource.dart';
import 'package:bloodconnect/donor_finder/appointments/0_data/models/appointment_model.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/repositories/appointment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentDataSource appointmentDataSource;

  AppointmentRepositoryImpl(this.appointmentDataSource);

  @override
  Future<Either<String, String>> createAppointment(
      Appointment appointment) async {
    try {
      final appointmentModel = AppointmentModel.fromEntity(appointment);
      final appointmentId =
          await appointmentDataSource.createAppointment(appointmentModel);
      return Right(appointmentId);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Appointment>>> getAppointmentsByUserId(
      String userId) async {
    try {
      final appointments =
          await appointmentDataSource.getAppointmentsByUserId(userId);
      return Right(appointments);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Appointment>> getAppointmentById(String id) async {
    try {
      final appointment = await appointmentDataSource.getAppointmentById(id);
      return Right(appointment);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> deleteAppointment(String id) async {
    try {
      final result = await appointmentDataSource.deleteAppointment(id);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> updateAppointment({
    required String appointmentId,
    DateTime? appointmentDate,
    TimeOfDay? appointmentTime,
    String? status,
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    try {
      // First get the current appointment
      final appointment =
          await appointmentDataSource.getAppointmentById(appointmentId);

      // Format time if provided
      String? formattedTime;
      if (appointmentTime != null) {
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, appointmentTime.hour,
            appointmentTime.minute);
        formattedTime = DateFormat('h:mm a').format(dt);
      }

      // Update the appointment with new values or keep existing ones
      final updatedAppointment = AppointmentModel(
        id: appointment.id,
        userId: appointment.userId,
        donorId: appointment.donorId,
        name: appointment.name,
        bloodType: appointment.bloodType,
        phoneNumber: appointment.phoneNumber,
        appointmentDate: appointmentDate ?? appointment.appointmentDate,
        appointmentTime: formattedTime ?? appointment.appointmentTime,
        hospital: appointment.hospital,
        notes: notes ?? appointment.notes,
        createdAt: appointment.createdAt,
        status: status ?? appointment.status,
        latitude: latitude ?? appointment.latitude,
        longitude: longitude ?? appointment.longitude,
      );

      final result =
          await appointmentDataSource.updateAppointment(updatedAppointment);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
