class CalendarFixture {
  const CalendarFixture({
    required this.day,
    required this.opponentName,
    required this.opponentCrestPath,
    required this.isAway,
  });

  final int day;
  final String opponentName;
  final String opponentCrestPath;
  final bool isAway;
}

const mockJulyFixtures = [
  CalendarFixture(
    day: 31,
    opponentName: 'Levante',
    opponentCrestPath: 'lib/assets/images/madrid.png',
    isAway: true,
  ),
];
