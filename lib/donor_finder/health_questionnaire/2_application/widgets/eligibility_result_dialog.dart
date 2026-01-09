import 'package:flutter/material.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/eligibility_result_entity.dart';

class EligibilityResultDialog extends StatelessWidget {
  final EligibilityResultEntity result;
  final VoidCallback onContinue;

  const EligibilityResultDialog({
    super.key,
    required this.result,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: result.isEligible
                    ? const Color(0xFFE8F5E8)
                    : const Color(0xFFFEE8E8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                result.isEligible
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                size: 40,
                color: result.isEligible
                    ? Colors.green[600]
                    : const Color(0xFFD32F2F),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              result.isEligible ? 'Eligible to Donate!' : 'Not Eligible',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: result.isEligible
                    ? Colors.green[600]
                    : const Color(0xFFD32F2F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              result.message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            // Show reasons for ineligibility if any
            if (!result.isEligible &&
                result.reasonsForIneligibility.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reasons:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...result.reasonsForIneligibility.map(
                      (reason) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(color: Color(0xFFD32F2F))),
                            Expanded(
                              child: Text(
                                reason,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFD32F2F),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Next eligible date if applicable
            if (result.nextEligibleDate != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Next Eligible Date:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${result.nextEligibleDate!.day}/${result.nextEligibleDate!.month}/${result.nextEligibleDate!.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
