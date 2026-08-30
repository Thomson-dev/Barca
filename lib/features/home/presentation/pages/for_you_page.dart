import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../data/for_you_mock_data.dart';
import '../widgets/featured_video_card.dart';
import '../widgets/match_center_card.dart';
import '../widgets/promo_banner_row.dart';
import '../widgets/story_highlight_row.dart';

/// The "For You" home feed: promo chips, story highlights, the next
/// fixture, and featured content. Populated from mock data for now.
class ForYouPage extends StatelessWidget {
  const ForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _ForYouAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        children: [
          const StoryHighlightRow(items: mockStoryHighlights),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MatchCenterCard(match: mockUpcomingMatch),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FeaturedVideoCard(item: mockFeaturedVideo),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

class _ForYouAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ForYouAppBar();

  static const _chipRowHeight = 40.0;
  static const _chipRowBottomPadding = 12.0;
  static const _chipRowPadding = EdgeInsets.only(bottom: _chipRowBottomPadding);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      leadingWidth: 52,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(Icons.shield, color: AppColors.gold),
      ),
      title: const Text(
        'FOR YOU',
        style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5, color: Colors.black),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => context.push(AppRoutes.welcome),
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: const BorderSide(color: Colors.black87),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('SIGN IN', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87, size: 20),
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
        preferredSize: const Size.fromHeight(_chipRowHeight + _chipRowBottomPadding),
        child: const Padding(
          padding: _chipRowPadding,
          child: PromoBannerRow(items: mockPromoBanners),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + _chipRowHeight + _chipRowBottomPadding);
}
