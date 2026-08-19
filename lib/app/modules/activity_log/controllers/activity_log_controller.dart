import 'package:get/get.dart';
import '../../../data/models/activity_event_model.dart';
import '../../../data/services/supabase_service.dart';

class ActivityLogController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  var events = <ActivityEventModel>[
    ActivityEventModel(id: 'ev-1', seniorId: 'senior-1', eventType: 'app_open', source: 'app', occurredAt: DateTime.now().subtract(const Duration(minutes: 5))),
    ActivityEventModel(id: 'ev-2', seniorId: 'senior-1', eventType: 'checkin_response', source: 'app', occurredAt: DateTime.now().subtract(const Duration(hours: 1))),
    ActivityEventModel(id: 'ev-3', seniorId: 'senior-1', eventType: 'medication_confirm', source: 'app', occurredAt: DateTime.now().subtract(const Duration(hours: 3))),
  ].obs;

  Future<void> logManualActivity() async {
    final event = ActivityEventModel(
      id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
      seniorId: 'mock-senior-id',
      eventType: 'manual_active',
      source: 'app',
      occurredAt: DateTime.now(),
    );
    events.insert(0, event);

    try {
      await _supabase.client.from('activity_events').insert(event.toJson());
    } catch (_) {}

    Get.snackbar('Logged', "Recorded 'I am Active' signal.");
  }
}
