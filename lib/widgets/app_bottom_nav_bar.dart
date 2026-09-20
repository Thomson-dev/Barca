import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentIndex, this.onTap});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const _unselectedColor = Colors.grey;
  static const _selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: NavigationBar(
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
          _destination(Iconsax.shield, 'For You'),
          _destination(Iconsax.calendar, 'Calendar'),
          _destination(Iconsax.document_text, 'Feeds'),
          _destination(Iconsax.profile, 'Profile'),
        ],
      ),
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
