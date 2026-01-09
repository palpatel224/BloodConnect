import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/screens/bloc/health_questionnaire_bloc.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/widgets/question_card.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/widgets/questionnaire_progress_indicator.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/widgets/eligibility_result_dialog.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/screens/home_screen.dart';

class HealthQuestionnaireScreen extends StatefulWidget {
  const HealthQuestionnaireScreen({super.key});

  @override
  State<HealthQuestionnaireScreen> createState() =>
      _HealthQuestionnaireScreenState();
}

class _HealthQuestionnaireScreenState extends State<HealthQuestionnaireScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<HealthQuestionnaireBloc>().add(LoadQuestionsEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Health Assessment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: BlocConsumer<HealthQuestionnaireBloc, HealthQuestionnaireState>(
        listener: (context, state) {
          if (state is HealthQuestionnaireCompleted) {
            _showEligibilityResult(context, state);
          } else if (state is HealthQuestionnaireError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HealthQuestionnaireLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD32F2F),
              ),
            );
          } else if (state is HealthQuestionnaireLoaded) {
            return Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: QuestionnaireProgressIndicator(
                    currentIndex: state.currentQuestionIndex,
                    totalQuestions: state.questions.length,
                  ),
                ),

                // Question content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.questions.length,
                    itemBuilder: (context, index) {
                      final question = state.questions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            QuestionCard(
                              question: question,
                              answer: state.answers[question.id],
                              onAnswerSelected: (answer) {
                                context.read<HealthQuestionnaireBloc>().add(
                                      AnswerQuestionEvent(
                                        questionId: question.id,
                                        answer: answer,
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Previous button
                      if (state.currentQuestionIndex > 0)
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {
                              context
                                  .read<HealthQuestionnaireBloc>()
                                  .add(PreviousQuestionEvent());
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color(0xFFD32F2F)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                color: Color(0xFFD32F2F),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      if (state.currentQuestionIndex > 0)
                        const SizedBox(width: 16),

                      // Next/Submit button
                      Expanded(
                        flex: state.currentQuestionIndex > 0 ? 2 : 1,
                        child: ElevatedButton(
                          onPressed: state.canProceed
                              ? () {
                                  if (state.isLastQuestion) {
                                    // Submit questionnaire
                                    final userId =
                                        FirebaseAuth.instance.currentUser?.uid;
                                    if (userId != null) {
                                      context
                                          .read<HealthQuestionnaireBloc>()
                                          .add(
                                            SubmitQuestionnaireEvent(
                                                userId: userId),
                                          );
                                    }
                                  } else {
                                    // Go to next question
                                    context
                                        .read<HealthQuestionnaireBloc>()
                                        .add(NextQuestionEvent());
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            state.isLastQuestion ? 'Submit' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is HealthQuestionnaireError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<HealthQuestionnaireBloc>()
                          .add(LoadQuestionsEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showEligibilityResult(
      BuildContext context, HealthQuestionnaireCompleted state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => EligibilityResultDialog(
        result: state.result,
        onContinue: () {
          Navigator.of(dialogContext).pop(); // Close dialog
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false, // Remove all previous routes
          );
        },
      ),
    );
  }
}
