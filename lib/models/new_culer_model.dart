class NewCulerItem {
  const NewCulerItem({
    required this.id,
    required this.name,
    required this.caption,
    required this.imagePath,
  });

  final String id;
  final String name;
  final String caption;
  final String imagePath;
}

const mockNewCulers = [
  NewCulerItem(
    id: '1',
    name: 'Rodri',
    caption: 'Rodri is a culer 🖐️',
    imagePath: 'lib/assets/images/1.jpeg',
  ),
  NewCulerItem(
    id: '2',
    name: 'Gabriel Jesus',
    caption: 'Gabriel Jesus is a culer',
    imagePath: 'lib/assets/images/2.jpeg',
  ),
  NewCulerItem(
    id: '3',
    name: 'Anthony Gordon',
    caption: 'Welcome, Anthony Gordon 💙❤️',
    imagePath: 'lib/assets/images/3.jpeg',
  ),
  NewCulerItem(
    id: '4',
    name: 'Cancelo',
    caption: 'Cancelo 2029 ✍️',
    imagePath: 'lib/assets/images/4.jpeg',
  ),
];
