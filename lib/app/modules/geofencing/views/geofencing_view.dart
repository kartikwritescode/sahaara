import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/geofence_controller.dart';
import '../../../core/constants/app_colors.dart';

class GeofencingView extends GetView<GeofenceController> {
  const GeofencingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location & Geofencing (M8)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final initialCamera = CameraPosition(
          target: controller.currentSeniorPos.value,
          zoom: 14.5,
        );

        final Set<Marker> markers = {
          Marker(
            markerId: const MarkerId('senior_loc'),
            position: controller.currentSeniorPos.value,
            infoWindow: const InfoWindow(title: 'Senior Location', snippet: 'Last ping 3 mins ago'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        };

        final Set<Circle> circles = controller.geofences.map((g) {
          if (g == null) return null;
          return Circle(
            circleId: CircleId(g.id),
            center: LatLng(g.centerLat, g.centerLng),
            radius: g.radiusM.toDouble(),
            strokeWidth: 2,
            strokeColor: AppColors.primary,
            fillColor: AppColors.primary.withOpacity(0.15),
          );
        }).whereType<Circle>().toSet();

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialCamera,
              markers: markers,
              circles: circles,
              myLocationEnabled: true,
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.shield, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Status: Inside Home Safe Zone', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Location pings feed into the AI risk engine anomaly detection term.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
