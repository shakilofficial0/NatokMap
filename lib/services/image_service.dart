import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Service for image handling and processing
class ImageService {
  static final ImageService instance = ImageService._init();
  final ImagePicker _picker = ImagePicker();

  ImageService._init();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Take photo with camera
  Future<File?> takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  /// Resize image to 800x600
  Future<File> resizeImage(File imageFile) async {
    try {
      // Read the image
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to 800x600 maintaining aspect ratio
      final resized = img.copyResize(
        image,
        width: 800,
        height: 600,
        interpolation: img.Interpolation.linear,
      );

      // Get app directory
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'landmark_$timestamp.jpg';
      final resizedFile = File(path.join(appDir.path, fileName));

      // Encode and save
      final encodedImage = img.encodeJpg(resized, quality: 85);
      await resizedFile.writeAsBytes(encodedImage);

      return resizedFile;
    } catch (e) {
      print('Error resizing image: $e');
      return imageFile;
    }
  }

  /// Save image locally
  Future<String?> saveImageLocally(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'landmark_$timestamp${path.extension(imageFile.path)}';
      final savedFile = File(path.join(appDir.path, fileName));

      await imageFile.copy(savedFile.path);
      return savedFile.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  /// Delete local image
  Future<bool> deleteLocalImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Get image file from path
  File? getImageFile(String? path) {
    if (path == null || path.isEmpty) return null;
    final file = File(path);
    return file.existsSync() ? file : null;
  }
}
