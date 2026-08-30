import 'package:flutter/material.dart';

import 'app_bottom_nav_bar.dart';

/// Placeholder for a bottom-nav tab that doesn't have a real screen yet.
/// Keeps navigation between tabs working while each one is built out.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, required this.title, required this.tabIndex});

  final String title;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title is coming soon', style: Theme.of(context).textTheme.titleMedium),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: tabIndex),
    );
  }
}
