import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// The pill-shaped "CONTINUE" call-to-action used across the auth flow.
/// Gold and tappable when [onPressed] is set, grey and inert otherwise.
class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key, required this.enabled, this.onPressed, this.label = 'Continue'});

  final bool enabled;
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black,
          disabledForegroundColor: Colors.grey.shade500,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
    );
  }
}
