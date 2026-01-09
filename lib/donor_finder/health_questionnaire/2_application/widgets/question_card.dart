import 'package:flutter/material.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/health_question_entity.dart';

class QuestionCard extends StatelessWidget {
  final HealthQuestionEntity question;
  final bool? answer;
  final Function(bool) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Question icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE8E8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline,
                size: 40,
                color: Color(0xFFD32F2F),
              ),
            ),
            const SizedBox(height: 24),

            // Question text
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              question.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Answer buttons
            Row(
              children: [
                Expanded(
                  child: _buildAnswerButton(
                    context: context,
                    text: 'Yes',
                    value: true,
                    isSelected: answer == true,
                    onTap: () => onAnswerSelected(true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnswerButton(
                    context: context,
                    text: 'No',
                    value: false,
                    isSelected: answer == false,
                    onTap: () => onAnswerSelected(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton({
    required BuildContext context,
    required String text,
    required bool value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD32F2F) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFD32F2F) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
