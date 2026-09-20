import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_colors.dart';

class SocialProfile {
  const SocialProfile({
    required this.handle,
    required this.name,
    required this.bio,
    required this.avatarColor,
    this.avatarAsset,
    this.postIndex,
    this.followers = 0,
    this.following = 0,
  });

  final String handle;
  final String name;
  final String bio;
  final Color avatarColor;
  final String? avatarAsset;
  final int? postIndex;
  final int followers;
  final int following;
}

const mockSocialProfiles = [
  SocialProfile(
    handle: 'culer',
    name: 'Culer',
    bio: 'Visca Barça, sempre! 🔵🔴',
    avatarColor: AppColors.blaugranaBlue,
    postIndex: 0,
    followers: 1200,
    following: 184,
  ),
  SocialProfile(
    handle: 'barca_fan',
    name: 'Barça fan',
    bio: 'Living for matchday and Barça moments ⚽',
    avatarColor: AppColors.blaugranaGarnet,
    avatarAsset: 'lib/assets/images/5.jpeg',
    postIndex: 1,
    followers: 4800,
    following: 312,
  ),
  SocialProfile(
    handle: 'cules',
    name: 'Cules',
    bio: 'More than a club. Every single day.',
    avatarColor: AppColors.gold,
    avatarAsset: 'lib/assets/images/raphinha.jpg',
    postIndex: 2,
    followers: 8200,
    following: 205,
  ),
  SocialProfile(
    handle: 'culer_1899',
    name: 'Culer 1899',
    bio: 'Here for every Barça goal.',
    avatarColor: AppColors.blaugranaBlue,
  ),
  SocialProfile(
    handle: 'matchdayfan',
    name: 'Matchday Fan',
    bio: 'Counting down to kickoff.',
    avatarColor: AppColors.blaugranaGarnet,
  ),
  SocialProfile(
    handle: 'barca.daily',
    name: 'Barça Daily',
    bio: 'All things Barça.',
    avatarColor: AppColors.gold,
  ),
];

SocialProfile profileForHandle(String handle) {
  for (final profile in mockSocialProfiles) {
    if (profile.handle == handle) return profile;
  }
  return SocialProfile(
    handle: handle,
    name: handle.replaceAll('_', ' '),
    bio: 'Barça supporter 🔵🔴',
    avatarColor: AppColors.blaugranaBlue,
  );
}

class FollowingController extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String handle) {
    final updated = {...state};
    if (!updated.add(handle)) updated.remove(handle);
    state = updated;
  }
}

final followingProvider = NotifierProvider<FollowingController, Set<String>>(
  FollowingController.new,
);
