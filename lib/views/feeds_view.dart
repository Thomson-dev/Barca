import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/post_model.dart';
import '../providers/post_providers.dart';
import '../controllers/social_profiles_controller.dart';
import '../services/app_colors.dart';
import '../services/app_routes.dart';
import '../widgets/app_bottom_nav_bar.dart';

// ================================================================
// FEED DATA
// ================================================================

class _FeedPost {
  final String username;
  final String handle;
  final Color avatarColor;
  final String caption;
  final String timeAgo;
  final List<String> images;
  final bool isVideo;
  final int likes;
  final int comments;
  final int reposts;
  final int shares;

  const _FeedPost({
    required this.username,
    required this.handle,
    required this.avatarColor,
    required this.caption,
    required this.timeAgo,
    this.images = const [],
    this.isVideo = false,
    this.likes = 0,
    this.comments = 0,
    this.reposts = 0,
    this.shares = 0,
  });
}

class _FeedComment {
  const _FeedComment(this.username, this.text, {this.replyTo});

  final String username;
  final String text;
  final String? replyTo;
}

class _SavedPosts extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  void toggle(int index) {
    final updated = {...state};
    if (!updated.add(index)) updated.remove(index);
    state = updated;
  }
}

final _savedPostsProvider = NotifierProvider<_SavedPosts, Set<int>>(
  _SavedPosts.new,
);

void _openProfile(BuildContext context, String handle) {
  context.push(
    handle == 'you' || handle == 'iam.culer'
        ? AppRoutes.profile
        : AppRoutes.userProfile(handle),
  );
}

String _timeAgo(DateTime createdAt) {
  final difference = DateTime.now().difference(createdAt);
  if (difference.inMinutes < 1) return 'now';
  if (difference.inHours < 1) return '${difference.inMinutes}m';
  if (difference.inDays < 1) return '${difference.inHours}h';
  return '${difference.inDays}d';
}

List<_FeedPost> _allPosts(List<Post> posts) {
  return posts.asMap().entries.map((entry) {
    final index = entry.key;
    final post = entry.value;
    return _FeedPost(
      username: 'You',
      handle: 'you',
      avatarColor: AppColors.blaugranaBlue,
      caption: post.caption ?? '',
      images: post.mediaUrl == null ? const [] : [post.mediaUrl!],
      isVideo: post.mediaType == 'video',
      timeAgo: _timeAgo(post.createdAt),
      likes: 320 + (index * 147),
      comments: 18 + (index * 11),
      reposts: 4 + index,
      shares: 7 + (index * 2),
    );
  }).toList();
}

// ================================================================
// FEEDS VIEW
// ================================================================

class FeedsView extends ConsumerStatefulWidget {
  const FeedsView({super.key, this.initialPostIndex = 0});

  final int initialPostIndex;

  @override
  ConsumerState<FeedsView> createState() => _FeedsViewState();
}

class _FeedsViewState extends ConsumerState<FeedsView> {
  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);
    final posts = _allPosts(postsState.asData?.value ?? const []);
    return Scaffold(
      backgroundColor: Colors.white,

      // ----------------------------------------------------------
      // APP BAR
      // ----------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Barça',
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.explore),
            tooltip: 'Explore users',
            icon: const Icon(Iconsax.search_normal),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.savedPosts),
            tooltip: 'Saved posts',
            icon: const Icon(Iconsax.bookmark),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Notifications',
            icon: const Icon(Iconsax.notification, color: Colors.black),
          ),
        ],
      ),

      // ----------------------------------------------------------
      // BODY
      // ----------------------------------------------------------
      body: postsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _FeedMessage(
          message: 'Could not load posts.',
          actionLabel: 'Try again',
          onAction: () => ref.read(postsProvider.notifier).refresh(),
        ),
        data: (_) => posts.isEmpty
            ? _FeedMessage(
                message: 'No posts yet. Start the conversation.',
                actionLabel: 'Create post',
                onAction: () => context.push(AppRoutes.createPost),
              )
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, position) {
                  final index =
                      (widget.initialPostIndex + position) % posts.length;
                  return _PostCard(
                    key: ValueKey(index),
                    post: posts[index],
                    index: index,
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createPost),
        backgroundColor: AppColors.blaugranaBlue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        tooltip: 'Create post',
        child: const Icon(Iconsax.add, size: 30),
      ),

      // ----------------------------------------------------------
      // BOTTOM NAVIGATION
      // ----------------------------------------------------------
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

class SavedPostsView extends ConsumerWidget {
  const SavedPostsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = _allPosts(ref.watch(postsProvider).asData?.value ?? const []);
    final savedIndexes = ref
        .watch(_savedPostsProvider)
        .where((index) => index < posts.length)
        .toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved posts')),
      body: savedIndexes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.bookmark, size: 56),
                    const SizedBox(height: 12),
                    Text(
                      'Nothing saved yet',
                      style: GoogleFonts.oswald(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Bookmark a post in the feed to see it here.'),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: savedIndexes.length,
              itemBuilder: (context, position) {
                final index = savedIndexes[position];
                final post = posts[index];
                return InkWell(
                  onTap: () => context.push(AppRoutes.feeds, extra: index),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (post.images.isNotEmpty)
                        post.isVideo
                            ? const ColoredBox(
                                color: Color(0xFF17273D),
                                child: Center(
                                  child: Icon(
                                    Iconsax.video_play,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              )
                            : Image.network(
                                post.images.first,
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
                                post.caption,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      if (post.isVideo)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Iconsax.play_circle,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 6, color: Colors.black54),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _FeedMessage extends StatelessWidget {
  const _FeedMessage({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.document, size: 44, color: AppColors.blaugranaBlue),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// POST CARD
// ================================================================

class _PostCard extends ConsumerStatefulWidget {
  const _PostCard({super.key, required this.post, required this.index});

  final _FeedPost post;
  final int index;

  @override
  ConsumerState<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<_PostCard> {
  int _currentPage = 0;
  bool _liked = false;
  bool _reposted = false;
  final List<_FeedComment> _newComments = [];

  void _showComments() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) => _CommentsSheet(
        post: widget.post,
        newComments: _newComments,
        onAdd: (comment) => setState(() => _newComments.add(comment)),
        onOpenProfile: (handle) {
          Navigator.pop(sheetContext);
          _openProfile(context, handle);
        },
      ),
    );
  }

  void _showShareSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => _ShareSheet(post: widget.post),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(count >= 10000 ? 0 : 1)}k';
    }
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final hasMultiple = post.images.length > 1;
    final bookmarked = ref.watch(_savedPostsProvider).contains(widget.index);
    final following = ref.watch(followingProvider).contains(post.handle);
    const muted = Color(0xFF667582);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _openProfile(context, post.handle),
                borderRadius: BorderRadius.circular(22),
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor: post.avatarColor,
                  child: Text(
                    post.username[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: InkWell(
                            onTap: () => _openProfile(context, post.handle),
                            child: Text(
                              post.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            '@${post.handle} · ${post.timeAgo}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: muted,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          height: 30,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            iconSize: 19,
                            tooltip: 'Post options',
                            onSelected: (value) {
                              if (value == 'follow') {
                                ref
                                    .read(followingProvider.notifier)
                                    .toggle(post.handle);
                              } else if (value == 'save') {
                                ref
                                    .read(_savedPostsProvider.notifier)
                                    .toggle(widget.index);
                              } else if (value == 'share') {
                                _showShareSheet();
                              }
                            },
                            itemBuilder: (context) => [
                              if (post.handle != 'iam.culer')
                                PopupMenuItem(
                                  value: 'follow',
                                  child: Text(
                                    following ? 'Unfollow' : 'Follow',
                                  ),
                                ),
                              PopupMenuItem(
                                value: 'save',
                                child: Text(
                                  bookmarked
                                      ? 'Remove from saved'
                                      : 'Save post',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'share',
                                child: Text('Share'),
                              ),
                            ],
                            icon: const Icon(Iconsax.more, color: muted),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      post.caption,
                      style: GoogleFonts.inter(fontSize: 15, height: 1.35),
                    ),
                    if (post.images.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: post.isVideo ? 0.75 : 0.68,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (post.isVideo)
                                Center(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      const ColoredBox(color: Color(0xFF17273D)),
                                      Center(
                                        child: Icon(
                                          Iconsax.play_circle,
                                          size: 64,
                                          color: Colors.white.withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                PageView.builder(
                                  itemCount: post.images.length,
                                  onPageChanged: (i) =>
                                      setState(() => _currentPage = i),
                                  itemBuilder: (context, index) => Image.network(
                                    post.images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const Center(
                                      child: Icon(Iconsax.image, size: 48),
                                    ),
                                  ),
                                ),
                              if (hasMultiple)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.55,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${_currentPage + 1}/${post.images.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _FeedAction(
                            icon: Iconsax.message,
                            count: _formatCount(
                              post.comments + _newComments.length,
                            ),
                            tooltip: 'Comments',
                            onTap: _showComments,
                          ),
                          _FeedAction(
                            icon: Iconsax.repeat,
                            count: _formatCount(
                              post.reposts + (_reposted ? 1 : 0),
                            ),
                            color: _reposted ? AppColors.blaugranaBlue : muted,
                            tooltip: 'Repost',
                            onTap: () => setState(() => _reposted = !_reposted),
                          ),
                          _FeedAction(
                            icon: _liked ? Iconsax.heart : Iconsax.heart,
                            count: _formatCount(post.likes + (_liked ? 1 : 0)),
                            color: _liked ? Colors.red : muted,
                            tooltip: 'Like',
                            onTap: () => setState(() => _liked = !_liked),
                          ),
                          _FeedAction(
                            icon: bookmarked
                                ? Iconsax.bookmark
                                : Iconsax.bookmark,
                            tooltip: bookmarked
                                ? 'Remove from saved'
                                : 'Save post',
                            onTap: () => ref
                                .read(_savedPostsProvider.notifier)
                                .toggle(widget.index),
                          ),
                          _FeedAction(
                            icon: Iconsax.export,
                            tooltip: 'Share',
                            onTap: _showShareSheet,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _FeedAction extends StatelessWidget {
  const _FeedAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.count,
    this.color = const Color(0xFF667582),
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final String? count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              if (count != null) ...[
                const SizedBox(width: 4),
                Text(
                  count!,
                  style: GoogleFonts.inter(fontSize: 11, color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  const _CommentsSheet({
    required this.post,
    required this.newComments,
    required this.onAdd,
    required this.onOpenProfile,
  });

  final _FeedPost post;
  final List<_FeedComment> newComments;
  final ValueChanged<_FeedComment> onAdd;
  final ValueChanged<String> onOpenProfile;

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _controller = TextEditingController();
  String? _replyTo;

  static const _sampleComments = [
    _FeedComment('culer_1899', 'Visca Barça! 🔵🔴'),
    _FeedComment('matchdayfan', 'What a moment!'),
    _FeedComment('barca.daily', 'Can’t wait for the next match 🙌'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.onAdd(_FeedComment('you', text, replyTo: _replyTo));
      _controller.clear();
      _replyTo = null;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final comments = [..._sampleComments, ...widget.newComments];
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final availableHeight = MediaQuery.sizeOf(context).height - keyboardHeight;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SizedBox(
        height: availableHeight * 0.7,
        child: Column(
          children: [
            Text(
              'Comments on @${widget.post.handle}',
              style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    contentPadding: EdgeInsets.only(
                      left: comment.replyTo == null ? 0 : 32,
                    ),
                    leading: InkWell(
                      onTap: () => widget.onOpenProfile(comment.username),
                      child: CircleAvatar(
                        child: Text(comment.username[0].toUpperCase()),
                      ),
                    ),
                    title: InkWell(
                      onTap: () => widget.onOpenProfile(comment.username),
                      child: Text(
                        comment.username,
                        style: GoogleFonts.oswald(fontWeight: FontWeight.w700),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.replyTo == null
                              ? comment.text
                              : '@${comment.replyTo} ${comment.text}',
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            _replyTo = comment.username;
                          }),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Reply'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            if (_replyTo != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: Text('Replying to @$_replyTo')),
                    IconButton(
                      onPressed: () => setState(() => _replyTo = null),
                      tooltip: 'Cancel reply',
                      icon: const Icon(Iconsax.close_circle, size: 18),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Iconsax.profile)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        hintText: 'Add a comment or reply…',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _submit,
                    tooltip: 'Post comment',
                    icon: const Icon(Iconsax.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareSheet extends StatefulWidget {
  const _ShareSheet({required this.post});

  final _FeedPost post;

  @override
  State<_ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<_ShareSheet> {
  static const _recipients = [
    'culer_1899',
    'matchdayfan',
    'barca.daily',
    'pedri.fan',
    'blaugrana.life',
  ];

  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Share post',
              style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.post.images.isNotEmpty
                    ? widget.post.isVideo
                        ? const ColoredBox(
                            color: Color(0xFF17273D),
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                Iconsax.video_play,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Image.network(
                        widget.post.images.first,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      )
                    : const ColoredBox(
                        color: Color(0xFFF1F2F6),
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Iconsax.note),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Post by @${widget.post.handle}',
                  style: GoogleFonts.oswald(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Send to',
            style: GoogleFonts.oswald(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final recipient in _recipients)
                FilterChip(
                  label: Text(recipient),
                  selected: _selected.contains(recipient),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _selected.add(recipient);
                    } else {
                      _selected.remove(recipient);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _selected.isEmpty
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sharing is a UI preview for now.'),
                        ),
                      );
                      Navigator.pop(context);
                    },
              child: Text('Send to ${_selected.length}'),
            ),
          ),
          const SizedBox(height: 4),
          const Center(child: Text('Preview only · Messages are not sent yet')),
        ],
      ),
    );
  }
}
