import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../controllers/social_profiles_controller.dart';
import '../providers/post_providers.dart';
import '../services/app_colors.dart';
import '../services/app_routes.dart';
import '../widgets/app_bottom_nav_bar.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreateSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) => _CreateSheet(
        onCreatePost: () {
          Navigator.pop(sheetContext);
          context.push(AppRoutes.createPost);
        },
      ),
    );
  }

  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (!mounted) return;

    final result = ref.read(authControllerProvider);
    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not sign out: ${result.error}')),
      );
      return;
    }

    context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isSigningOut = authState.isLoading;
    final user = authState.value;
    final metadata = user?.userMetadata;
    final fullName = [metadata?['first_name'], metadata?['last_name']]
        .whereType<String>()
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .join(' ');
    final displayName = fullName.isNotEmpty
        ? fullName
        : user?.email ?? 'My profile';
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // ----------------------------------------------------------------
      // APP BAR
      // ----------------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: _showCreateSheet,
          tooltip: 'Create',
          icon: const Icon(Iconsax.add),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Iconsax.arrow_down_2, color: Colors.black, size: 20),
          ],
        ),
        actions: [
          IconButton(
            onPressed: isSigningOut ? null : _signOut,
            tooltip: 'Log out',
            icon: isSigningOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Iconsax.logout),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.savedPosts),
            tooltip: 'Saved posts',
            icon: const Icon(Iconsax.bookmark),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.explore),
            tooltip: 'Explore users',
            icon: const Icon(Iconsax.search_normal),
          ),
        ],
      ),

      // ----------------------------------------------------------------
      // BODY
      // ----------------------------------------------------------------
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --------------------------------------------------------
                // AVATAR + STATS ROW
                // --------------------------------------------------------

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'lib/assets/images/member.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(
                                  Iconsax.profile,
                                  size: 44,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: AppColors.blaugranaBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.add,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 24),

                      // Stats
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Consumer(
                              builder: (context, ref, child) => _StatItem(
                                label: 'posts',
                                value: '${ref.watch(postsProvider).asData?.value.length ?? 0}',
                              ),
                            ),
                            InkWell(
                              onTap: () => context.push(
                                AppRoutes.userFollowers('iam.culer'),
                              ),
                              child: const _StatItem(
                                label: 'followers',
                                value: '0',
                              ),
                            ),
                            Consumer(
                              builder: (context, ref, child) => InkWell(
                                onTap: () => context.push(
                                  AppRoutes.userFollowing('iam.culer'),
                                ),
                                child: _StatItem(
                                  label: 'following',
                                  value:
                                      '${ref.watch(followingProvider).length}',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // --------------------------------------------------------
                // NAME + BIO
                // --------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFonts.oswald(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),

                      if (user?.email != null)
                        Text(
                          user!.email!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),

                      const SizedBox(height: 2),

                      Text(
                        'Més que un club 💙❤️',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Row(
                        children: [
                          const Icon(
                            Iconsax.link,
                            size: 14,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'fcbarcelona.com',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.blaugranaBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Member badge
                      Chip(
                        backgroundColor: Colors.transparent,

                        side: BorderSide.none,
                        avatar: const Icon(
                          Iconsax.shield,
                          size: 16,
                          color: AppColors.blaugranaBlue,
                        ),
                        label: const Text('Culer Member'),
                        visualDensity: VisualDensity.compact,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // --------------------------------------------------------
                // DASHBOARD CARD
                // --------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: const Color(0xFFF1F2F6),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your dashboard',
                              style: GoogleFonts.oswald(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '0 views in the last 30 days.',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // --------------------------------------------------------
                // ACTION BUTTONS
                // --------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Edit profile',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          label: 'Share profile',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(icon: Iconsax.profile_add, onTap: () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --------------------------------------------------------
                // STORY HIGHLIGHTS
                // --------------------------------------------------------
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _HighlightBubble(isNew: true, onTap: () {}),
                      _HighlightBubble(
                        label: 'Matchday',
                        color: AppColors.blaugranaBlue,
                        onTap: () {},
                      ),
                      _HighlightBubble(
                        label: 'Goals',
                        color: AppColors.blaugranaGarnet,
                        onTap: () {},
                      ),
                      _HighlightBubble(
                        label: 'Skills',
                        color: AppColors.gold,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),

          // TAB BAR
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBar(tabController: _tabController),
          ),
        ],

        // ----------------------------------------------------------------
        // POSTS GRID
        // ----------------------------------------------------------------
        body: TabBarView(
          controller: _tabController,
          children: const [
            _OwnPostsGrid(),
            _OwnPostsGrid(mediaType: 'photo'),
            _OwnPostsGrid(mediaType: 'video'),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}

// ================================================================
// CREATE SHEET
// ================================================================

class _CreateSheet extends StatelessWidget {
  const _CreateSheet({required this.onCreatePost});

  final VoidCallback onCreatePost;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Create',
          style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        _CreateOption(
          icon: Iconsax.video_play,
          label: 'Reel',
          onTap: () => Navigator.pop(context),
        ),
        _CreateOption(
          icon: Iconsax.element_4,
          label: 'Edits',
          isNew: true,
          onTap: () => Navigator.pop(context),
        ),
        _CreateOption(icon: Iconsax.grid_1, label: 'Post', onTap: onCreatePost),
        _CreateOption(
          icon: Iconsax.add_circle,
          label: 'Story',
          onTap: () => Navigator.pop(context),
        ),
        _CreateOption(
          icon: Iconsax.heart,
          label: 'Highlights',
          onTap: () => Navigator.pop(context),
        ),
        _CreateOption(
          icon: Iconsax.radar,
          label: 'Live',
          showDivider: false,
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _CreateOption extends StatelessWidget {
  const _CreateOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isNew = false,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isNew;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(label, style: GoogleFonts.inter(fontSize: 17)),
          trailing: isNew
              ? const Badge(
                  label: Text('New'),
                  backgroundColor: Color(0xFF6670FF),
                )
              : null,
          onTap: onTap,
        ),
        if (showDivider) const Divider(height: 1, indent: 56, endIndent: 16),
      ],
    );
  }
}

// ================================================================
// STAT ITEM
// ================================================================

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// ACTION BUTTON
// ================================================================

class _ActionButton extends StatelessWidget {
  const _ActionButton({this.label, this.icon, required this.onTap});

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: const Color(0xFFF1F2F6),
      foregroundColor: Colors.black,
      minimumSize: const Size(40, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
    );

    return icon != null
        ? IconButton.filledTonal(
            onPressed: onTap,
            tooltip: 'Discover people',
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1F2F6),
              foregroundColor: Colors.black,
            ),
            icon: Icon(icon, size: 18),
          )
        : FilledButton.tonal(
            onPressed: onTap,
            style: style,
            child: Text(label!),
          );
  }
}

// ================================================================
// HIGHLIGHT BUBBLE
// ================================================================

class _HighlightBubble extends StatelessWidget {
  const _HighlightBubble({
    this.label,
    this.isNew = false,
    this.color,
    required this.onTap,
  });

  final String? label;
  final bool isNew;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 40,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNew ? Colors.white : color ?? Colors.grey.shade200,
                border: Border.all(
                  color: isNew ? Colors.grey.shade300 : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: isNew
                  ? const Icon(Iconsax.add, size: 28, color: Colors.black)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              isNew ? 'New' : label ?? '',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class _OwnPostsGrid extends ConsumerWidget {
  const _OwnPostsGrid({this.mediaType});

  final String? mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider).asData?.value ?? const [];
    final indexes = [
      for (var i = posts.length - 1; i >= 0; i--)
        if (mediaType == null ||
            (mediaType == 'video'
                ? posts[i].mediaType == 'video'
                : posts[i].mediaUrl != null && posts[i].mediaType != 'video'))
          i,
    ];
    if (indexes.isEmpty) {
      return Center(
        child: Text(
          'No ${mediaType ?? 'posts'} yet',
          style: GoogleFonts.inter(),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
      ),
      itemCount: indexes.length,
      itemBuilder: (context, index) {
        final postIndex = indexes[index];
        final post = posts[postIndex];
        return InkWell(
          onTap: () => context.push(AppRoutes.feeds, extra: postIndex),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (post.mediaUrl != null)
                Image.network(
                  post.mediaUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: Color(0xFFF1F2F6),
                    child: Icon(Iconsax.image),
                  ),
                )
              else
                ColoredBox(
                  color: const Color(0xFFF1F2F6),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        post.caption ?? '',
                        style: GoogleFonts.inter(),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              if (post.mediaType == 'video')
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Iconsax.play_circle, color: Colors.white),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ================================================================
// STICKY TAB BAR DELEGATE
// ================================================================

class _StickyTabBar extends SliverPersistentHeaderDelegate {
  const _StickyTabBar({required this.tabController});

  final TabController tabController;

  @override
  double get minExtent => 44;
  @override
  double get maxExtent => 44;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: TabBar(
        controller: tabController,
        indicatorColor: Colors.black,
        indicatorWeight: 2,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(),
        tabs: const [
          Tab(text: 'Posts'),
          Tab(text: 'Photos'),
          Tab(text: 'Videos'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTabBar oldDelegate) => false;
}
