class FeaturedVideoItem {
  const FeaturedVideoItem({
    required this.title,
    required this.sponsor,
    this.isNew = false,
  });

  final String title;
  final String sponsor;
  final bool isNew;
}

const mockFeaturedVideo = FeaturedVideoItem(
  title: 'Jornada 2',
  sponsor: 'Spotify',
  isNew: true,
);
