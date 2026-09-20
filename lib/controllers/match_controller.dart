import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/match_event_model.dart';
import '../models/match_model.dart';

class MatchController {
  final SupabaseClient supabase;

  MatchController(this.supabase);

  Future<List<MatchModel>> getMatches() async {
    try {
      final response = await supabase
          .from('matches')
          .select()
          .order('kickoff_time');

      final rawData = List<Map<String, dynamic>>.from(response as List);
      return rawData.map((json) => MatchModel.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<MatchModel?> getMatchById(String id) async {
    try {
      final response = await supabase
          .from('matches')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return MatchModel.fromJson(response);
    } catch (_) {
      return null;
    }
  }

  Future<List<MatchEventModel>> getMatchEvents(String matchId) async {
    try {
      final response = await supabase
          .from('match_events')
          .select()
          .eq('match_id', matchId)
          .order('minute');

      final rawData = List<Map<String, dynamic>>.from(response as List);
      return rawData.map((json) => MatchEventModel.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }
}
