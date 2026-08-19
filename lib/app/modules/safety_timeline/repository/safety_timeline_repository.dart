import 'package:get/get.dart';
import '../models/timeline_entry.dart';
import '../../../data/services/supabase_service.dart';

class SafetyTimelineRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<TimelineEntry>> getTimeline(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('activity_events')
          .select()
          .eq('senior_id', seniorId)
          .order('timestamp', ascending: false);
      return (res as List).map((e) => TimelineEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
