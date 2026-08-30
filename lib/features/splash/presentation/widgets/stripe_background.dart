import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Vertical blaugrana stripes, each shaded darker at the top and bottom
/// edges, behind [child].
class StripeBackground extends StatelessWidget {
  const StripeBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StripePainter(),
      child: SizedBox.expand(child: child),
    );
  }
}

class _StripePainter extends CustomPainter {
  static const _stripeCount = 13;

  static final _darkBlue = Color.lerp(AppColors.blaugranaBlue, Colors.black, 0.45)!;
  static final _darkGarnet = Color.lerp(AppColors.blaugranaGarnet, Colors.black, 0.45)!;

  @override
  void paint(Canvas canvas, Size size) {
    final stripeWidth = size.width / _stripeCount;

    for (var i = 0; i < _stripeCount; i++) {
      final isBlue = i.isEven;
      final rect = Rect.fromLTWH(i * stripeWidth, 0, stripeWidth, size.height);
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isBlue
              ? [_darkBlue, AppColors.blaugranaBlue, _darkBlue]
              : [_darkGarnet, AppColors.blaugranaGarnet, _darkGarnet],
        ).createShader(rect);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StripePainter oldDelegate) => false;
}
