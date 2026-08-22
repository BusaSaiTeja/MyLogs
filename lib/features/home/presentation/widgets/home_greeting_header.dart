import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';

class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({super.key, required this.now});
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${AppDateUtils.greeting()}, ',
                style: AppTypography.display.copyWith(color: AppColors.onSurface),
              ),
              TextSpan(
                text: 'You 👋',
                style: AppTypography.display.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppDateUtils.greetingDate(now),
          style: AppTypography.bodyLgVariant(),
        ),
      ],
    );
  }
}
