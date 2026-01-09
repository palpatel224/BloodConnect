import 'package:bloodconnect/health_worker/donation_appointments/2_application/screens/appointment_list_screen.dart';
import 'package:bloodconnect/health_worker/donor_list/2_application/screens/donor_list.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/bloc/health_worker_home_bloc.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/widgets/action_button_widget.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/widgets/request_card.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/widgets/empty_state_widget.dart';
import 'package:bloodconnect/health_worker/manage_request/2_application/screens/manage_request_screen.dart';
import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class HealthWorkerHomePage extends StatelessWidget {
  const HealthWorkerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<HealthWorkerHomeBloc>()..add(LoadHealthWorkerHome()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<HealthWorkerHomeBloc, HealthWorkerHomeState>(
            builder: (context, state) {
              if (state is HealthWorkerHomeLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xFFD32F2F),
                ));
              }

              if (state is HealthWorkerHomeError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is HealthWorkerHomeLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<HealthWorkerHomeBloc>()
                        .add(LoadHealthWorkerHome());
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // User profile section
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello,",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  state.userName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                FirebaseAuth.instance.currentUser?.photoURL ??
                                    'https://via.placeholder.com/150',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Health worker stats card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Role pill
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Health Worker",
                                    style: TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              // Stats row
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: _buildStatsRow(state),
                              ),

                              // Current status message
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  _getStatusMessage(state),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Quick Actions section
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Quick Actions",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                // Manage Requests action
                                Expanded(
                                  child: Center(
                                    child: ActionButton(
                                      icon: Icons.bloodtype_outlined,
                                      label: "Manage\nRequests",
                                      color: const Color(0xFFFEE8E8),
                                      iconColor: const Color(0xFFD32F2F),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ManageRequestScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                // Verify Donation action
                                Expanded(
                                  child: Center(
                                    child: ActionButton(
                                      icon: Icons.check_circle_outline,
                                      label: "Verify\nDonation",
                                      color: const Color(0xFFFEE8E8),
                                      iconColor: const Color(0xFFD32F2F),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AppointmentListScreen()));
                                      },
                                    ),
                                  ),
                                ),

                                // Find Donor action
                                Expanded(
                                  child: Center(
                                    child: ActionButton(
                                      icon: Icons.search,
                                      label: "Find\nDonor",
                                      color: const Color(0xFFFEE8E8),
                                      iconColor: const Color(0xFFD32F2F),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DonorList(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Recent Blood Requests section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Recent Blood Requests",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ManageRequestScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "See All",
                                    style: TextStyle(
                                      color: Color(0xFFD32F2F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            state.requests.isEmpty
                                ? const EmptyStateWidget(
                                    title: "No recent requests",
                                    subtitle:
                                        "Blood requests from patients will appear here",
                                    icon: Icons.water_drop_outlined)
                                : Column(
                                    children: state.requests
                                        .take(3)
                                        .map((request) => Column(
                                              children: [
                                                RequestCard(
                                                  patientName:
                                                      request.patientName,
                                                  time: _getTimeAgo(
                                                      request.createdAt),
                                                  bloodType: request.bloodType,
                                                  priority:
                                                      request.urgencyLevel,
                                                ),
                                                const Divider(),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(HealthWorkerHomeLoaded state) {
    // Calculate statistics from the request data
    final pendingRequests = state.requests
        .where((req) => req.requestStatus == RequestStatus.pending)
        .length;

    final totalUnits =
        state.requests.fold<int>(0, (sum, req) => sum + req.units);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pending requests count
        Expanded(
          child: Column(
            children: [
              Text(
                "$pendingRequests",
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Pending Requests",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Vertical divider
        Container(
          height: 50,
          width: 1,
          color: Colors.grey[300],
        ),

        // Total units needed
        Expanded(
          child: Column(
            children: [
              Text(
                "$totalUnits",
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Units Needed",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusMessage(HealthWorkerHomeLoaded state) {
    final pendingRequests = state.requests
        .where((req) => req.requestStatus == RequestStatus.pending)
        .length;

    if (pendingRequests == 0) {
      return "No pending requests at the moment";
    } else {
      return "$pendingRequests pending blood request${pendingRequests > 1 ? 's' : ''} to review";
    }
  }

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown time';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
