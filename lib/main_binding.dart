import 'package:get/get.dart';
import 'app/data/services/supabase_service.dart';
import 'app/data/services/maps_service.dart';
import 'app/data/services/cloudinary_service.dart';
import 'app/data/services/notification_service.dart';
import 'app/data/services/risk_calc_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SupabaseService>(SupabaseService(), permanent: true);
    Get.put<MapsService>(MapsService(), permanent: true);
    Get.put<CloudinaryService>(CloudinaryService(), permanent: true);
    Get.put<NotificationService>(NotificationService(), permanent: true);
    Get.put<RiskCalcService>(RiskCalcService(), permanent: true);
  }
}
