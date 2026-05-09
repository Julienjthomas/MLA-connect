import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StepperHeader extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color? accentColor;

  const StepperHeader({
    super.key,
    required this.steps,
    required this.currentStep,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                // Connector line
                final stepIndex = i ~/ 2;
                final isCompleted = stepIndex < currentStep;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted ? color : AppColors.grey200,
                  ),
                );
              }
              // Step dot
              final stepIndex = i ~/ 2;
              final isCompleted = stepIndex < currentStep;
              final isActive = stepIndex == currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? color
                      : isActive
                          ? Colors.white
                          : AppColors.grey200,
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: color, width: 2) : null,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : Center(
                        child: Text(
                          '${stepIndex + 1}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isActive ? color : AppColors.grey500,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.asMap().entries.map((e) {
              final isActive = e.key == currentStep;
              final isCompleted = e.key < currentStep;
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 40) / steps.length,
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: isActive || isCompleted ? color : AppColors.textHint,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
