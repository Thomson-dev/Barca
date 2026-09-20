class StoryHighlightItem {
  const StoryHighlightItem({
    required this.id,
    required this.label,
    required this.imagePath,
  });

  final String id;
  final String label;
  final String imagePath;
}

const mockStoryHighlights = [
  StoryHighlightItem(
    id: '1',
    label: 'Final session',
    imagePath: 'lib/assets/images/1.jpeg',
  ),
  StoryHighlightItem(
    id: '2',
    label: 'ELC vs FCB',
    imagePath: 'lib/assets/images/2.jpeg',
  ),
  StoryHighlightItem(
    id: '3',
    label: 'Opening days',
    imagePath: 'lib/assets/images/3.jpeg',
  ),
  StoryHighlightItem(
    id: '4',
    label: 'Did you know',
    imagePath: 'lib/assets/images/4.jpeg',
  ),
  StoryHighlightItem(
    id: '5',
    label: 'Opening days',
    imagePath: 'lib/assets/images/5.jpeg',
  ),
  StoryHighlightItem(
    id: '6',
    label: 'Did you know',
    imagePath: 'lib/assets/images/6.jpeg',
  ),
];
