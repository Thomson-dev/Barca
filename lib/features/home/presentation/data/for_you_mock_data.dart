import 'package:flutter/material.dart';

/// UI-only view models for the "For You" feed. There's no backend for this
/// feature yet, so the page is populated from the mock data below.

class PromoBannerItem {
  const PromoBannerItem({
    required this.icon,
    required this.label,
    this.isNew = false,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final bool isNew;

  /// True for the single solid-black "hero" chip (Barça Play); the rest
  /// render as white outlined chips.
  final bool filled;
}

class StoryHighlightItem {
  const StoryHighlightItem({required this.label});

  final String label;
}

class UpcomingMatch {
  const UpcomingMatch({
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
    required this.sponsor,
    required this.cheerCount,
  });

  final String homeTeam;
  final String awayTeam;
  final DateTime kickoff;
  final String sponsor;
  final int cheerCount;
}

class FeaturedVideoItem {
  const FeaturedVideoItem({required this.title, required this.sponsor, this.isNew = false});

  final String title;
  final String sponsor;
  final bool isNew;
}

const mockPromoBanners = [
  PromoBannerItem(icon: Icons.play_arrow_rounded, label: 'Barça Play', filled: true),
  PromoBannerItem(icon: Icons.confirmation_number_outlined, label: 'Next Matches'),
  PromoBannerItem(icon: Icons.checkroom_outlined, label: 'Third Kit', isNew: true),
  PromoBannerItem(icon: Icons.wb_sunny_outlined, label: 'Summer Museum'),
];

const mockStoryHighlights = [
  StoryHighlightItem(label: 'Final session'),
  StoryHighlightItem(label: 'ELC vs FCB'),
  StoryHighlightItem(label: 'Opening days'),
  StoryHighlightItem(label: 'Did you know'),
];

final mockUpcomingMatch = UpcomingMatch(
  homeTeam: 'Elche',
  awayTeam: 'Barça',
  kickoff: DateTime.now().add(const Duration(days: 5, hours: 8, minutes: 31)),
  sponsor: '1XBET',
  cheerCount: 89934,
);

const mockFeaturedVideo = FeaturedVideoItem(title: 'Jornada 2', sponsor: 'Spotify', isNew: true);
r