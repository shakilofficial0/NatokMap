import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/landmark.dart';
import '../repositories/landmark_repository.dart';
import '../services/image_service.dart';
import '../services/location_service.dart';

/// Controller: Manages business logic for landmarks
/// Follows MVC architecture pattern
class LandmarkController extends ChangeNotifier {
  final LandmarkRepository _repository = LandmarkRepository.instance;
  final ImageService _imageService = ImageService.instance;
  final LocationService _locationService = LocationService.instance;

  List<Landmark> _landmarks = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOnline = true;

  List<Landmark> get landmarks => _landmarks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOnline => _isOnline;

  /// Load all landmarks
  Future<void> loadLandmarks({bool forceRefresh = false}) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _repository.fetchAllLandmarks(
        forceRefresh: forceRefresh,
      );

      if (response.success && response.data != null) {
        _landmarks = response.data!;
        _isOnline = !response.message!.contains('offline');
      } else {
        _setError(response.message ?? 'Failed to load landmarks');
      }
    } catch (e) {
      _setError('Error loading landmarks: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new landmark
  Future<bool> createLandmark({
    required String title,
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Resize image before uploading
      final resizedImage = await _imageService.resizeImage(imageFile);

      final response = await _repository.createLandmark(
        title: title,
        latitude: latitude,
        longitude: longitude,
        imageFile: resizedImage,
      );

      if (response.success) {
        await loadLandmarks(forceRefresh: true);
        return true;
      } else {
        _setError(response.message ?? 'Failed to create landmark');
        return false;
      }
    } catch (e) {
      _setError('Error creating landmark: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing landmark
  Future<bool> updateLandmark({
    required int id,
    required String title,
    required double latitude,
    required double longitude,
    File? imageFile,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      File? processedImage;
      if (imageFile != null) {
        processedImage = await _imageService.resizeImage(imageFile);
      }

      final response = await _repository.updateLandmark(
        id: id,
        title: title,
        latitude: latitude,
        longitude: longitude,
        imageFile: processedImage,
      );

      if (response.success) {
        await loadLandmarks(forceRefresh: true);
        return true;
      } else {
        _setError(response.message ?? 'Failed to update landmark');
        return false;
      }
    } catch (e) {
      _setError('Error updating landmark: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a landmark
  Future<bool> deleteLandmark(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _repository.deleteLandmark(id);

      if (response.success) {
        _landmarks.removeWhere((landmark) => landmark.id == id);
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? 'Failed to delete landmark');
        return false;
      }
    } catch (e) {
      _setError('Error deleting landmark: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get landmark by ID
  Landmark? getLandmarkById(int id) {
    try {
      return _landmarks.firstWhere((landmark) => landmark.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    return await _imageService.pickImageFromGallery();
  }

  /// Take photo with camera
  Future<File?> takePhoto() async {
    return await _imageService.takePhoto();
  }

  /// Get current location
  Future<Map<String, double>?> getCurrentLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    }
    return null;
  }

  /// Check connectivity
  Future<void> checkConnectivity() async {
    _isOnline = await _repository.isOnline();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Clear all data
  void clear() {
    _landmarks.clear();
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
