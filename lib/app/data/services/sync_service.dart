import 'package:get/get.dart';

class SyncService extends GetxService {
  Future<SyncService> init() async => this;
  final RxBool isOffline = false.obs;
}
