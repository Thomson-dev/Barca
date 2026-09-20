import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../providers/repository_providers.dart';
import '../services/app_colors.dart';
import '../services/app_routes.dart';
import '../widgets/stripe_background.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {

  @override
  void initState() {
    super.initState();
    unawaited(_restoreSessionAndNavigate());
  }

  Future<void> _restoreSessionAndNavigate() async {
    final minimumSplash = Future<void>.delayed(const Duration(seconds: 3));
    bool hasSession;
    try {
      hasSession = await ref.read(authRepositoryProvider).restoreSession() != null;
    } catch (_) {
      hasSession = false;
    }
    await minimumSplash;
    if (!mounted) return;
    context.go(hasSession ? AppRoutes.home : AppRoutes.welcome);
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
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Iconsax.shield, color: AppColors.gold, size: 56),
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
