import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_typography.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, required this.title, this.actionLabel, this.onAction});
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTypography.headlineMd),
        const Spacer(),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!, style: AppTypography.labelMdPrimary()),
          ),
      ],
    );
  }
}
