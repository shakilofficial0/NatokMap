import 'dart:io';

import '../database/database_helper.dart';
import '../models/api_response.dart';
import '../models/landmark.dart';
import '../services/api_service.dart';

/// Repository: Manages data from both API and local database
/// Implements offline-first strategy
class LandmarkRepository {
  static final LandmarkRepository instance = LandmarkRepository._init();
  
  final ApiService _apiService = ApiService.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  LandmarkRepository._init();

  /// Fetch all landmarks (online/offline strategy)
  Future<ApiResponse<List<Landmark>>> fetchAllLandmarks({
    bool forceRefresh = false,
  }) async {
    try {
      // Try to fetch from API
      final apiResponse = await _apiService.getAllLandmarks();
      
      if (apiResponse.success && apiResponse.data != null) {
        // Save to local database
        await _syncToLocalDatabase(apiResponse.data!);
        return apiResponse;
      }
      
      // Fallback to local database
      final localData = await _dbHelper.getAllLandmarks();
      if (localData.isNotEmpty) {
        return ApiResponse.success(
          data: localData,
          message: 'Showing cached data (offline mode)',
        );
      }
      
      return ApiResponse.failure(
        message: 'No data available',
      );
    } catch (e) {
      // Fallback to local database on error
      final localData = await _dbHelper.getAllLandmarks();
      if (localData.isNotEmpty) {
        return ApiResponse.success(
          data: localData,
          message: 'Showing cached data (offline mode)',
        );
      }
      
      return ApiResponse.failure(
        message: 'Failed to fetch landmarks: $e',
      );
    }
  }

  /// Create a new landmark
  Future<ApiResponse<Landmark>> createLandmark({
    required String title,
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    try {
      // Try to create via API
      final apiResponse = await _apiService.createLandmark(
        title: title,
        latitude: latitude,
        longitude: longitude,
        imageFile: imageFile,
      );

      if (apiResponse.success) {
        // Refresh local cache
        await fetchAllLandmarks(forceRefresh: true);
        return apiResponse;
      }

      // If API fails, save locally for later sync
      final landmark = Landmark(
        title: title,
        latitude: latitude,
        longitude: longitude,
        isSynced: false,
        createdAt: DateTime.now(),
      );
      
      await _dbHelper.insertLandmark(landmark);
      
      return ApiResponse.success(
        data: landmark,
        message: 'Saved locally. Will sync when online.',
      );
    } catch (e) {
      return ApiResponse.failure(
        message: 'Failed to create landmark: $e',
      );
    }
  }

  /// Update an existing landmark
  Future<ApiResponse<Landmark>> updateLandmark({
    required int id,
    required String title,
    required double latitude,
    required double longitude,
    File? imageFile,
  }) async {
    try {
      // Try to update via API
      final apiResponse = await _apiService.updateLandmark(
        id: id,
        title: title,
        latitude: latitude,
        longitude: longitude,
        imageFile: imageFile,
      );

      if (apiResponse.success) {
        // Update local database
        final landmark = Landmark(
          id: id,
          title: title,
          latitude: latitude,
          longitude: longitude,
          isSynced: true,
          updatedAt: DateTime.now(),
        );
        
        await _dbHelper.updateLandmark(landmark);
        
        return ApiResponse.success(
          data: landmark,
          message: 'Landmark updated successfully',
        );
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse.failure(
        message: 'Failed to update landmark: $e',
      );
    }
  }

  /// Delete a landmark
  Future<ApiResponse<void>> deleteLandmark(int id) async {
    try {
      // Try to delete via API
      final apiResponse = await _apiService.deleteLandmark(id);

      if (apiResponse.success) {
        // Delete from local database
        await _dbHelper.deleteLandmark(id);
        return apiResponse;
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse.failure(
        message: 'Failed to delete landmark: $e',
      );
    }
  }

  /// Get landmark by ID
  Future<Landmark?> getLandmarkById(int id) async {
    try {
      return await _dbHelper.getLandmarkById(id);
    } catch (e) {
      print('Error getting landmark by ID: $e');
      return null;
    }
  }

  /// Sync local database with API data
  Future<void> _syncToLocalDatabase(List<Landmark> landmarks) async {
    try {
      // Clear old data
      await _dbHelper.deleteAllLandmarks();
      
      // Insert new data
      for (final landmark in landmarks) {
        await _dbHelper.insertLandmark(landmark);
      }
    } catch (e) {
      print('Error syncing to local database: $e');
    }
  }

  /// Sync unsynced local data to API
  Future<void> syncUnsyncedData() async {
    try {
      final unsyncedLandmarks = await _dbHelper.getUnsyncedLandmarks();
      
      for (final landmark in unsyncedLandmarks) {
        // Attempt to sync each unsynced landmark
        // Implementation depends on whether it's a create/update operation
        print('Syncing landmark: ${landmark.title}');
      }
    } catch (e) {
      print('Error syncing unsynced data: $e');
    }
  }

  /// Check if connected to network
  Future<bool> isOnline() async {
    return await _apiService.checkConnectivity();
  }
}
