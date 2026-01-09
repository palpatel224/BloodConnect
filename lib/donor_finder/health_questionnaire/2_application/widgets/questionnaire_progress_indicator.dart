import 'package:flutter/material.dart';

class QuestionnaireProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;

  const QuestionnaireProgressIndicator({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / totalQuestions;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentIndex + 1} of $totalQuestions',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${((progress) * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD32F2F)),
          minHeight: 8,
        ),
      ],
    );
  }
}
