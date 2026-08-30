import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/stripe_background.dart';

/// Branded splash shown after the native launch screen, before the app
/// hands off to the auth flow.
///
/// TODO: swap [_Crest]'s icon for the real FC Barcelona crest image, and
/// [_SponsorRow]'s text for the real Nike/Spotify/Midea logos, once those
/// asset files are added to lib/assets/images/.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _goToWelcome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToWelcome() {
    if (!mounted) return;
    context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StripeBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              const _Crest(),
              const SizedBox(height: 24),
              Text(
                'FC BARCELONA',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'MÉS QUE UN CLUB',
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3,
                ),
              ),
              const Spacer(flex: 5),
              const _SponsorRow(),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _Crest extends StatelessWidget {
  const _Crest();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: const Icon(Icons.shield, color: AppColors.gold, size: 56),
    );
  }
}

class _SponsorRow extends StatelessWidget {
  const _SponsorRow();

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.montserrat(
      color: Colors.white.withValues(alpha: 0.75),
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('NIKE', style: style),
          Text('SPOTIFY', style: style),
          Text('MIDEA', style: style),
        ],
      ),
    );
  }
}
