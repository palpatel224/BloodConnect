import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/screens/home_screen.dart';
import 'package:bloodconnect/donor_worker_option.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/screens/health_questionnaire_screen.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/check_questionnaire_completion_usecase.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/screens/home_page.dart';
import 'package:bloodconnect/login/2_application/screens/login_screen.dart';
import 'package:bloodconnect/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

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
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder<List<bool>>(
                future: Future.wait([
                  checkIfDonorExists(),
                  checkIfHealthWorkerExists(),
                ]),
                builder: (context, checkSnapshot) {
                  if (checkSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = checkSnapshot.data;
                  final isDonor = data != null && data[0];
                  final isHealthWorker = data != null && data[1];

                  if (isDonor && !isHealthWorker) {
                    // Check if donor has completed questionnaire
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      return FutureBuilder<bool>(
                        future: sl<CheckQuestionnaireCompletionUseCase>()(
                            currentUser.uid),
                        builder: (context, questionnaireSnapshot) {
                          if (questionnaireSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final hasCompletedQuestionnaire =
                              questionnaireSnapshot.data ?? false;

                          if (hasCompletedQuestionnaire) {
                            return const HomeScreen();
                          } else {
                            return const HealthQuestionnaireScreen();
                          }
                        },
                      );
                    } else {
                      return const DonorWorkerOption();
                    }
                  } else if (isHealthWorker && !isDonor) {
                    return const HealthWorkerHomePage();
                  } else {
                    return const DonorWorkerOption();
                  }
                },
              );
            } else {
              return LoginScreen();
            }
          }),
    );
  }
}
