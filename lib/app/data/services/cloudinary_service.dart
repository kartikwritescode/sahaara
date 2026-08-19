import 'package:get/get.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../../core/env/env.dart';

class CloudinaryService extends GetxService {
  CloudinaryPublic? _cloudinary;

  @override
  void onInit() {
    super.onInit();
    if (Env.cloudinaryCloudName.isNotEmpty && Env.cloudinaryUploadPreset.isNotEmpty) {
      _cloudinary = CloudinaryPublic(
        Env.cloudinaryCloudName,
        Env.cloudinaryUploadPreset,
        cache: false,
      );
    }
  }

  Future<String?> uploadImage(String filePath, {String folder = 'avatars'}) async {
    if (_cloudinary == null) return null;
    try {
      CloudinaryResponse response = await _cloudinary!.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          folder: folder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }
}
