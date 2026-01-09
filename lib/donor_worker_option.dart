import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/screens/home_screen.dart';
import 'package:bloodconnect/donor_finder/donor_info/2_application/screens/donor_info.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/screens/health_questionnaire_screen.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/check_questionnaire_completion_usecase.dart';
import 'package:bloodconnect/health_worker/worker_info/2_application/screens/health_worker_info.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/screens/home_page.dart';
import 'package:bloodconnect/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorWorkerOption extends StatefulWidget {
  const DonorWorkerOption({super.key});

  @override
  State<DonorWorkerOption> createState() => _DonorWorkerOptionState();
}

class _DonorWorkerOptionState extends State<DonorWorkerOption> {
  Future<bool> checkIfDonorExists() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        return false;
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Donor_Finder')
          .doc(currentUser.uid)
          .get();
      return userDoc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkIfHealthWorkerExists() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        return false;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Health_Worker')
          .doc(currentUser.uid)
          .get();

      return userDoc.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              _buildRoleCard(
                title: 'Health Worker',
                description: 'Register patients, manage blood requests',
                iconColor: Colors.blue,
                iconData: Icons.person_add,
                isSelected: false,
                onTap: () async {
                  bool userExists = await checkIfHealthWorkerExists();
                  if (userExists) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HealthWorkerHomePage(),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HealthWorkerInfo()),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildRoleCard(
                title: 'Donor',
                description: 'Donate blood, view requests, save lives',
                iconColor: Colors.red,
                iconData: Icons.favorite,
                isSelected: true,
                onTap: () async {
                  bool userExists = await checkIfDonorExists();
                  if (userExists) {
                    // Existing donor, check if they need to complete questionnaire
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      final checkQuestionnaireUseCase =
                          sl<CheckQuestionnaireCompletionUseCase>();
                      bool hasCompletedQuestionnaire =
                          await checkQuestionnaireUseCase(currentUser.uid);

                      if (hasCompletedQuestionnaire) {
                        // Questionnaire completed, go to home screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      } else {
                        // Questionnaire not completed, go to questionnaire screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HealthQuestionnaireScreen(),
                          ),
                        );
                      }
                    }
                  } else {
                    // New donor, go to donor info screen first
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonorInformationScreen(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 50),
              const Text(
                'Your contribution can save lives',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required Color iconColor,
    required IconData iconData,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
