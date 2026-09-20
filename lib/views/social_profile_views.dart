import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/social_profiles_controller.dart';
import '../services/app_routes.dart';

class OtherProfileView extends ConsumerWidget {
  const OtherProfileView({super.key, required this.handle});

  final String handle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = profileForHandle(handle);
    final following = ref.watch(followingProvider).contains(handle);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text('@${profile.handle}')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ProfileAvatar(profile: profile, radius: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ProfileStat(
                              value: profile.postIndex == null ? 0 : 1,
                              label: 'posts',
                            ),
                            InkWell(
                              onTap: () =>
                                  context.push(AppRoutes.userFollowers(handle)),
                              child: _ProfileStat(
                                value: profile.followers + (following ? 1 : 0),
                                label: 'followers',
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  context.push(AppRoutes.userFollowing(handle)),
                              child: _ProfileStat(
                                value: profile.following,
                                label: 'following',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    profile.name,
                    style: GoogleFonts.oswald(fontWeight: FontWeight.w700),
                  ),
                  Text(profile.bio),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: following
                        ? OutlinedButton(
                            onPressed: () => ref
                                .read(followingProvider.notifier)
                                .toggle(handle),
                            child: const Text('Following'),
                          )
                        : FilledButton.tonal(
                            onPressed: () => ref
                                .read(followingProvider.notifier)
                                .toggle(handle),
                            child: const Text('Follow'),
                          ),
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Posts'),
                Tab(text: 'Photos'),
                Tab(text: 'Videos'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _UserPosts(profile: profile),
                  _UserPosts(profile: profile, mediaType: 'photo'),
                  _UserPosts(profile: profile, mediaType: 'video'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserPosts extends StatelessWidget {
  const _UserPosts({required this.profile, this.mediaType});

  final SocialProfile profile;
  final String? mediaType;

  @override
  Widget build(BuildContext context) {
    final postIndex = profile.postIndex;
    final isVideo = postIndex == 2;
    final hasPost =
        postIndex != null &&
        (mediaType == null ||
            (mediaType == 'video' ? isVideo : !isVideo && postIndex != 0));
    if (!hasPost) {
      return const Center(child: Text('No posts here yet'));
    }

    final image = switch (postIndex) {
      1 => 'lib/assets/images/5.jpeg',
      2 => 'lib/assets/images/raphinha.jpg',
      _ => null,
    };
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      children: [
        InkWell(
          onTap: () => context.push(AppRoutes.feeds, extra: postIndex),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null)
                Image.asset(image, fit: BoxFit.cover)
              else
                const ColoredBox(
                  color: Color(0xFFF1F2F6),
                  child: Center(child: Text('Visca Barça 🔵🔴')),
                ),
              if (isVideo)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Iconsax.play_circle, color: Colors.white),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExploreUsersView extends StatefulWidget {
  const ExploreUsersView({super.key});

  @override
  State<ExploreUsersView> createState() => _ExploreUsersViewState();
}

class _ExploreUsersViewState extends State<ExploreUsersView> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final matches = mockSocialProfiles.where((profile) {
      final query = _query.toLowerCase();
      return profile.handle.toLowerCase().contains(query) ||
          profile.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Explore people')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Search users',
              leading: const Icon(Iconsax.search_normal),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) =>
                  _UserTile(profile: matches[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class PeopleListView extends ConsumerWidget {
  const PeopleListView({
    super.key,
    required this.handle,
    required this.showFollowers,
  });

  final String handle;
  final bool showFollowers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwn = handle == 'iam.culer';
    final people = isOwn
        ? showFollowers
              ? <SocialProfile>[]
              : mockSocialProfiles
                    .where(
                      (profile) =>
                          ref.watch(followingProvider).contains(profile.handle),
                    )
                    .toList()
        : mockSocialProfiles
              .where((profile) => profile.handle != handle)
              .take(showFollowers ? 4 : 3)
              .toList();

    return Scaffold(
      appBar: AppBar(title: Text(showFollowers ? 'Followers' : 'Following')),
      body: people.isEmpty
          ? Center(
              child: Text(
                showFollowers ? 'No followers yet' : 'Not following anyone yet',
              ),
            )
          : ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) =>
                  _UserTile(profile: people[index]),
            ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.profile});

  final SocialProfile profile;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _ProfileAvatar(profile: profile, radius: 22),
      title: Text('@${profile.handle}'),
      subtitle: Text(profile.name),
      trailing: const Icon(Iconsax.arrow_right_3),
      onTap: () => context.push(AppRoutes.userProfile(profile.handle)),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.profile, required this.radius});

  final SocialProfile profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: profile.avatarColor,
      backgroundImage: profile.avatarAsset == null
          ? null
          : AssetImage(profile.avatarAsset!),
      child: profile.avatarAsset == null
          ? Text(
              profile.name[0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: radius * 0.75),
            )
          : null,
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$value',
          style: GoogleFonts.oswald(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        Text(label),
      ],
    );
  }
}
