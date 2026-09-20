enum MatchStatus { scheduled, live, finished, postponed, cancelled }

class MatchModel {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final String homeCrest;
  final String awayCrest;
  final DateTime kickoffTime;
  final MatchStatus status;
  final int? homeScore;
  final int? awayScore;

  MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeCrest,
    required this.awayCrest,
    required this.kickoffTime,
    required this.status,
    this.homeScore,
    this.awayScore,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'],
      homeTeam: json['home_team'],
      awayTeam: json['away_team'],
      homeCrest: json['home_crest'],
      awayCrest: json['away_crest'],
      kickoffTime: DateTime.parse(json['kickoff_time']),
      status: MatchStatus.values.firstWhere((e) => e.name == json['status']),
      homeScore: json['home_score'],
      awayScore: json['away_score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'home_team': homeTeam,
      'away_team': awayTeam,
      'home_crest': homeCrest,
      'away_crest': awayCrest,
      'kickoff_time': kickoffTime.toIso8601String(),
      'status': status.name,
      'home_score': homeScore,
      'away_score': awayScore,
    };
  }
}
