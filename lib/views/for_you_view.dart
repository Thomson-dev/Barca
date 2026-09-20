import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/for_you_mock_data.dart';
import '../services/app_routes.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/featured_video_card.dart';
import '../widgets/match_center_card.dart';
import '../widgets/new_culers_section.dart';
import '../widgets/promo_banner_row.dart';
import '../widgets/story_highlight_row.dart';

class ForYouView extends StatelessWidget {
  const ForYouView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const _ForYouAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        children: [
          const SizedBox(height: 15),
          const StoryHighlightRow(),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MatchCenterCard(match: mockUpcomingMatch),
          ),
          const SizedBox(height: 24),
          const NewCulersSection(),
          const SizedBox(height: 24),

          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FeaturedVideoCard(item: mockFeaturedVideo),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'LEVANTE 🐸',
                  style: GoogleFonts.oswald(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 50),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'More',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Iconsax.arrow_right_3,
                        size: 20,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

class _ForYouAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ForYouAppBar();

  static const _chipRowHeight = 50.0;
  static const _chipRowBottomPadding = 1.0;
  static const _chipRowPadding = EdgeInsets.only(bottom: _chipRowBottomPadding);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 3,
      leadingWidth: 52,
      leading: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: Image.asset(
          'lib/assets/images/member.png',
          width: 18,
          height: 18,
          errorBuilder: (_, __, ___) =>
              const Icon(Iconsax.shield, size: 18, color: Colors.amber),
        ),
      ),
      title: Text(
        'FOR YOU',
        style: GoogleFonts.oswald(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: 0.5,
          color: const Color(0xFF050505),
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.white70.withValues(alpha: 0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: OutlinedButton(
            onPressed: () => context.push(AppRoutes.welcome),
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              side: const BorderSide(color: Color(0xFFE2E2E2), width: 1.5),
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              minimumSize: Size.zero,
            ),
            child: Text(
              'SIGN IN',
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Iconsax.setting, color: Colors.black87, size: 30),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings is coming soon')),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(
          _chipRowHeight + _chipRowBottomPadding,
        ),
        child: const Padding(
          padding: _chipRowPadding,
          child: PromoBannerRow(items: mockPromoBanners),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
    kToolbarHeight + _chipRowHeight + _chipRowBottomPadding,
  );
}
