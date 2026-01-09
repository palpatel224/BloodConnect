import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/0_data/models/appointment_model.dart';
import 'package:bloodconnect/donor_finder/appointments/2_application/screens/bloc/appointments_bloc.dart';
import 'package:bloodconnect/donor_finder/appointments/2_application/screens/donation_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bloodconnect/service_locator.dart';

class DonorAppointments extends StatefulWidget {
  const DonorAppointments({super.key});

  @override
  _DonorAppointmentsState createState() => _DonorAppointmentsState();
}

class _DonorAppointmentsState extends State<DonorAppointments> {
  String activeTab = "upcoming";
  late AppointmentsBloc _appointmentsBloc;

  @override
  void initState() {
    super.initState();
    _appointmentsBloc = sl<AppointmentsBloc>();
    _loadAppointments();
  }

  void _loadAppointments() {
    _appointmentsBloc.add(const GetUserAppointmentsEvent(userId: ''));
  }

  // Format date for display
  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  // Filter appointments based on active tab
  List<Appointment> getFilteredAppointments(List<Appointment> appointments) {
    final now = DateTime.now();

    return appointments.where((appointment) {
      final isUpcoming = appointment.appointmentDate.isAfter(now) ||
          isSameDay(appointment.appointmentDate, now);

      if (activeTab == "upcoming") {
        return isUpcoming &&
            (appointment.status == AppointmentModel.STATUS_PENDING ||
                appointment.status == AppointmentModel.STATUS_COMPLETED);
      } else {
        return !isUpcoming ||
            appointment.status == AppointmentModel.STATUS_COMPLETED ||
            appointment.status == AppointmentModel.STATUS_CANCELLED;
      }
    }).toList();
  }

  // Helper function to check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void handleReschedule(String appointmentId) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    // Show date picker then time picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Appointment'),
        content: const Text(
            'Please select a new date and time for your appointment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // Show date picker
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFFE60000),
                        onPrimary: Colors.white,
                      ),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                selectedDate = pickedDate;

                // Show time picker
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFFE60000),
                          onPrimary: Colors.white,
                        ),
                        dialogBackgroundColor: Colors.white,
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedTime != null) {
                  selectedTime = pickedTime;

                  // Confirm the rescheduling
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Reschedule'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${formatDate(selectedDate!)}'),
                          const SizedBox(height: 8),
                          Text('Time: ${_formatTimeOfDay(selectedTime!)}'),
                          const SizedBox(height: 16),
                          const Text(
                              'Do you want to reschedule this appointment?'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Update appointment with new date and time
                            _appointmentsBloc.add(UpdateAppointmentEvent(
                              appointmentId: appointmentId,
                              appointmentDate: selectedDate,
                              appointmentTime: selectedTime,
                            ));
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFE60000)),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            child: const Text('Select Date & Time'),
          ),
        ],
      ),
    );
  }

  // Helper to format TimeOfDay for display
  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('h:mm a').format(dt);
  }

  void handleCancel(String appointmentId) {
    // Delete appointment when user confirms
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content:
            const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Delete appointment
              _appointmentsBloc
                  .add(DeleteAppointmentEvent(appointmentId: appointmentId));
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );
  }

  void scheduleNewAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonationFormScreen()),
    ).then((_) => _loadAppointments());
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade50;
      case 'pending':
        return Colors.amber.shade50;
      case 'completed':
        return Colors.blue.shade50;
      case 'cancelled':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 50, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(
            activeTab == "upcoming"
                ? 'No upcoming appointments'
                : 'No past appointments',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          if (activeTab == "upcoming") ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scheduleNewAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60000),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Schedule Donation',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final date = appointment.appointmentDate;
    final dayNumber = date.day.toString();
    final month = DateFormat('MMM').format(date);
    final year = date.year.toString();
    final now = DateTime.now();
    final isPastDate = date.isBefore(now) && !isSameDay(date, now);

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Container
                SizedBox(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dayNumber,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE60000),
                        ),
                      ),
                      Text(
                        month,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        year,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                // Appointment Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.appointmentTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        appointment.hospital,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        appointment.hospital,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  height: 24,
                  child: Text(
                    appointment.status[0].toUpperCase() +
                        appointment.status.substring(1),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (appointment.notes.isNotEmpty) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      appointment.notes,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 15),
            // Action buttons
            Row(
              children: [
                if (!isPastDate &&
                    appointment.status.toLowerCase() != 'cancelled' &&
                    appointment.status.toLowerCase() != 'completed')
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today,
                          size: 16, color: Color(0xFFE60000)),
                      label: const Text(
                        'Reschedule',
                        style: TextStyle(
                            color: Color(0xFFE60000),
                            fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => handleReschedule(appointment.id),
                    ),
                  ),
                if (!isPastDate &&
                    appointment.status.toLowerCase() != 'cancelled' &&
                    appointment.status.toLowerCase() != 'completed')
                  const SizedBox(width: 10),
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(Icons.delete_outline,
                        size: 16, color: Colors.red[600]),
                    label: const Text(
                      'Delete Appointment',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEBEE),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => handleCancel(appointment.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFE60000)),
          SizedBox(height: 16),
          Text("Loading appointments...")
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            "Error loading appointments",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadAppointments,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE60000),
              foregroundColor: Colors.white,
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _appointmentsBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF333333)),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'My Appointments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFFE60000)),
                      onPressed: scheduleNewAppointment,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => activeTab = "upcoming"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: activeTab == "upcoming"
                                    ? const Color(0xFFE60000)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Upcoming',
                            style: TextStyle(
                              fontSize: 14,
                              color: activeTab == "upcoming"
                                  ? const Color(0xFFE60000)
                                  : Colors.grey[600],
                              fontWeight: activeTab == "upcoming"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => activeTab = "past"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: activeTab == "past"
                                    ? const Color(0xFFE60000)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Past',
                            style: TextStyle(
                              fontSize: 14,
                              color: activeTab == "past"
                                  ? const Color(0xFFE60000)
                                  : Colors.grey[600],
                              fontWeight: activeTab == "past"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Appointments List
              Expanded(
                child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
                  listener: (context, state) {
                    // Show success message when appointment is deleted
                    if (state is AppointmentDeleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Appointment deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Reload appointments after deletion
                      _loadAppointments();
                    } else if (state is AppointmentsError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${state.message}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AppointmentsLoading) {
                      return _buildLoadingIndicator();
                    } else if (state is AppointmentsError) {
                      return _buildErrorState(state.message);
                    } else if (state is AppointmentsLoaded) {
                      final filteredAppointments =
                          getFilteredAppointments(state.appointments);
                      return filteredAppointments.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.all(15),
                              itemCount: filteredAppointments.length,
                              itemBuilder: (context, index) =>
                                  _buildAppointmentCard(
                                      filteredAppointments[index]),
                            );
                    } else {
                      // Initial state or any other states
                      return _buildEmptyState();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
