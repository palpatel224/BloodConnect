import 'package:bloodconnect/donor_finder/appointments/2_application/screens/appointments_screen.dart';
import 'package:bloodconnect/donor_finder/find_donor/2_application/screens/find_donor.dart';
import 'package:bloodconnect/donor_finder/request_screen/2_application/screens/request_screen.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/widgets/action_button_widget.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/widgets/urgent_request_card_widget.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/widgets/appointment_card_widget.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/widgets/donation_history_card_widget.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/widgets/empty_state_widget.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/widgets/donation_eligibility_card_widget.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/screens/bloc/donor_finder_home_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloodconnect/service_locator.dart' as di;
import 'package:bloodconnect/donor_finder/find_donor/2_application/screens/bloc/find_request_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  String bloodType = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Donor_Finder')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          setState(() {
            userName = userData['name'] ?? "User";
            bloodType = userData['bloodType'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<DonorFinderHomeScreenBloc>()..add(LoadAppointmentsEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
            BlocBuilder<DonorFinderHomeScreenBloc, DonorFinderHomeScreenState>(
          builder: (context, state) {
            if (state is DonorFinderHomeScreenInitial ||
                state is DonorFinderHomeScreenLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DonorFinderHomeScreenError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is DonorFinderHomeScreenLoaded) {
              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<DonorFinderHomeScreenBloc>()
                        .add(RefreshHomeScreenDataEvent());
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
                                  userName,
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

                      // Blood donation stats card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Blood type pill
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE8E8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    bloodType,
                                    style: const TextStyle(
                                      color: Color(0xFFD32F2F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              // Stats row
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Donations count
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "${state.totalDonations}",
                                            style: const TextStyle(
                                              fontSize: 38,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            "Donations",
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

                                    // Credits count instead of Lives impacted
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "${state.userCredits}",
                                            style: const TextStyle(
                                              fontSize: 38,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            "Credits",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Upcoming donations message
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
                                  state.upcomingAppointments.isEmpty
                                      ? "No upcoming donations scheduled"
                                      : "${state.upcomingAppointments.length} upcoming donation(s) scheduled",
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Find Requests action
                                ActionButton(
                                  icon: Icons.search,
                                  label: "Find Requests",
                                  color: const Color(0xFFFEE8E8),
                                  iconColor: const Color(0xFFD32F2F),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                                create: (context) =>
                                                    di.sl<FindRequestBloc>()
                                                      ..add(LoadRequests()),
                                                child: const FindDonor())));
                                  },
                                ),

                                // Request Blood action
                                ActionButton(
                                  icon: Icons.water_drop_outlined,
                                  label: "Request Blood",
                                  color: const Color(0xFFFEE8E8),
                                  iconColor: const Color(0xFFD32F2F),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RequestScreen()));
                                  },
                                ),

                                // Schedule action
                                ActionButton(
                                  icon: Icons.calendar_today,
                                  label: "Schedule",
                                  color: const Color(0xFFFEE8E8),
                                  iconColor: const Color(0xFFD32F2F),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DonorAppointments()));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Urgent Blood Requests section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Urgent Blood Requests",
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
                                        builder: (context) => BlocProvider(
                                          create: (context) =>
                                              di.sl<FindRequestBloc>()
                                                ..add(LoadRequests()),
                                          child: const FindDonor(),
                                        ),
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
                            state.urgentRequests.isEmpty
                                ? const EmptyStateWidget(
                                    title: "No urgent requests",
                                    subtitle:
                                        "There are no urgent blood requests at the moment",
                                    icon: Icons.water_drop_outlined)
                                : Column(
                                    children: state.urgentRequests
                                        .map<Widget>(
                                            (request) => UrgentRequestCard(
                                                  request: request,
                                                  distance: '',
                                                ))
                                        .toList(),
                                  ),
                          ],
                        ),
                      ),

                      // Upcoming Appointments section
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Upcoming Appointments",
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
                                            DonorAppointments(),
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
                            state.upcomingAppointments.isEmpty
                                ? const EmptyStateWidget(
                                    title: "No upcoming appointments",
                                    subtitle:
                                        "Schedule a donation to help save lives",
                                    icon: Icons.calendar_today)
                                : Column(
                                    children: state.upcomingAppointments
                                        .map((appointment) => AppointmentCard(
                                            appointment: appointment))
                                        .toList(),
                                  ),
                          ],
                        ),
                      ),

                      // Recent Donations section
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 16.0, bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Recent Donations",
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
                                            DonorAppointments(),
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
                            state.recentDonations.isEmpty
                                ? const EmptyStateWidget(
                                    title: "No donation history",
                                    subtitle:
                                        "Your completed donations will appear here",
                                    icon: Icons.water_drop_outlined)
                                : Column(
                                    children: state.recentDonations
                                        .map((donation) => DonationHistoryCard(
                                            donation: donation))
                                        .toList(),
                                  ),
                          ],
                        ),
                      ),

                      // Donation Eligibility Section
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 16.0, bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Donation Eligibility",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            DonationEligibilityCard(
                              isEligibleToDonate: state.isEligibleToDonate,
                              nextEligibleDate: state.nextEligibleDate,
                              daysUntilEligible: state.daysUntilEligible,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
