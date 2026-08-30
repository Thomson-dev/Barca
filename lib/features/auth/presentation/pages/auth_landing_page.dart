import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/app_routes.dart';
import '../widgets/auth_scaffold.dart';

/// First screen of the auth flow: choose how to register or log in.
class AuthLandingPage extends StatelessWidget {
  const AuthLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Register for free or log in',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          _AuthOptionButton(
            label: 'Email',
            icon: const Icon(Icons.mail_outline, size: 25, color: Colors.black),
            onPressed: () => context.push(AppRoutes.login),
          ),
          const SizedBox(height: 12),
          _AuthOptionButton(
            label: 'Google',
            icon: Image.asset('lib/assets/images/goggle.png', width: 25, height: 30),
            onPressed: () => _showComingSoon(context, 'Google sign-in'),
          ),
          const SizedBox(height: 12),
          _AuthOptionButton(
            label: 'Member',
          icon: Image.asset('lib/assets/images/member.png', width: 25, height: 30),
            onPressed: () => _showComingSoon(context, 'Member sign-in'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon')),
    );
  }
}

class _AuthOptionButton extends StatelessWidget {
  const _AuthOptionButton({required this.label, required this.icon, required this.onPressed});

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
           const SizedBox(width: 12),
                 Text(
                  label.toUpperCase(),
                  style: GoogleFonts.oswald(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Colors.black,
                  ),
                ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
