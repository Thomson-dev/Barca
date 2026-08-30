import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../router/app_routes.dart';

/// Shared bottom navigation chrome reused across top-level tabs
/// (For You, Calendar, Clips, Store, Profile). Unselected items render
/// muted grey; the active item is solid black and bold.
///
/// Tapping a different tab navigates to its route via [AppRoutes.bottomNavTabs]
/// unless [onTap] is provided to override that behavior.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const _unselectedColor = Colors.grey;
  static const _selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent,
      selectedIndex: currentIndex,
      onDestinationSelected: onTap ?? (index) => _navigate(context, index),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return GoogleFonts.oswald(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? _selectedColor : _unselectedColor,
        );
      }),
      destinations: [
        _destination(Icons.shield_outlined, 'For You'),
        _destination(Icons.calendar_today_outlined, 'Calendar'),
        _destination(Icons.play_circle_outline, 'Clips'),
        _destination(Icons.shopping_bag_outlined, 'Store'),
        _destination(Icons.person_outline, 'Profile'),
      ],
    );
  }

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;
    context.go(AppRoutes.bottomNavTabs[index]);
  }

  static NavigationDestination _destination(IconData icon, String label) {
    return NavigationDestination(
      icon: Icon(icon, size: 25, color: _unselectedColor),
      selectedIcon: Icon(icon, size: 25, color: _selectedColor),
      label: label,
    );
  }
}
