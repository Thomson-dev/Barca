enum MatchEventType { goal, yellowCard, redCard, substitution }

class MatchEventModel {
  final String id;
  final String matchId;
  final MatchEventType type;
  final String player;
  final int minute;

  MatchEventModel({
    required this.id,
    required this.matchId,
    required this.type,
    required this.player,
    required this.minute,
  });

  factory MatchEventModel.fromJson(Map<String, dynamic> json) {
    return MatchEventModel(
      id: json['id'],
      matchId: json['match_id'],
      type: MatchEventType.values.firstWhere((e) => e.name == json['type']),
      player: json['player'],
      minute: json['minute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_id': matchId,
      'type': type.name,
      'player': player,
      'minute': minute,
    };
  }
}
