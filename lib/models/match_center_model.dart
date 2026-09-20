class UpcomingMatch {
  const UpcomingMatch({
    required this.homeTeam,
    required this.homeCrestPath,
    required this.awayTeam,
    required this.awayCrestPath,
    required this.kickoff,
    required this.sponsor,
    required this.cheerCount,
  });

  final String homeTeam;
  final String homeCrestPath;
  final String awayTeam;
  final String awayCrestPath;
  final DateTime kickoff;
  final String sponsor;
  final int cheerCount;
}

final mockUpcomingMatch = UpcomingMatch(
  homeCrestPath: 'lib/assets/images/member.png',
  homeTeam: 'MANCHESTER UNITED',
  awayTeam: 'PARIS SAINT-GERMAIN',
  awayCrestPath: 'lib/assets/images/madrid.png',
  kickoff: DateTime.now().add(const Duration(days: 5, hours: 8, minutes: 31)),
  sponsor: '1XBET',
  cheerCount: 89934,
);
