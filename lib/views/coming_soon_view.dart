import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav_bar.dart';

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    super.key,
    required this.title,
    required this.tabIndex,
  });

  final String title;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title is coming soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: tabIndex),
    );
  }
}
