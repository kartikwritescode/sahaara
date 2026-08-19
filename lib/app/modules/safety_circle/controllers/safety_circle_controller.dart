import 'package:get/get.dart';

class SafetyCircleController extends GetxController {
  var contacts = <Map<String, dynamic>>[
    {'name': 'Sarah Smith (Daughter)', 'priority': 1, 'is_primary': true, 'role': 'Primary Caregiver'},
    {'name': 'David Smith (Son)', 'priority': 2, 'is_primary': false, 'role': 'Secondary Caregiver'},
    {'name': 'John (Neighbor)', 'priority': 3, 'is_primary': false, 'role': 'Local Emergency Contact'},
  ].obs;
}
