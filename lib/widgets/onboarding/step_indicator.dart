import 'package:flutter/material.dart';

/// Step indicator widget for multi-step forms
class StepIndicator extends StatelessWidget {
  final int step;
  final int currentStep;
  final String label;

  const StepIndicator({
    super.key,
    required this.step,
    required this.currentStep,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = step == currentStep;
    final isCompleted = step < currentStep;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isActive
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// Connector line between step indicators
class StepConnector extends StatelessWidget {
  final int step;
  final int currentStep;

  const StepConnector({
    super.key,
    required this.step,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = step < currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 32),
        color: isCompleted ? Theme.of(context).primaryColor : Colors.grey[300],
      ),
    );
  }
}

/// Progress bar showing all steps
class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: List.generate(
          stepLabels.length * 2 - 1,
          (index) {
            if (index.isEven) {
              // Step indicator
              final stepIndex = index ~/ 2;
              return StepIndicator(
                step: stepIndex,
                currentStep: currentStep,
                label: stepLabels[stepIndex],
              );
            } else {
              // Connector
              final stepIndex = index ~/ 2;
              return StepConnector(
                step: stepIndex,
                currentStep: currentStep,
              );
            }
          },
        ),
      ),
    );
  }
}
