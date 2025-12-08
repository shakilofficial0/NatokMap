import 'dart:io';

import 'package:dio/dio.dart';

import '../models/api_response.dart';
import '../models/landmark.dart';

/// API Service for communicating with REST endpoints
class ApiService {
  static final ApiService instance = ApiService._init();
  late final Dio _dio;
  
  static const String baseUrl = 'https://labs.anontech.info/cse489/t3';
  static const String apiEndpoint = '/api.php';

  ApiService._init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  /// Create a new landmark (POST)
  Future<ApiResponse<Landmark>> createLandmark({
    required String title,
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'lat': latitude,
        'lon': longitude,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        apiEndpoint,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return ApiResponse.success(
            data: Landmark.fromJson(data),
            message: 'Landmark created successfully',
          );
        }
        return ApiResponse.success(message: 'Landmark created');
      }

      return ApiResponse.failure(
        message: 'Failed to create landmark',
      );
    } on DioException catch (e) {
      return ApiResponse.failure(
        message: _handleError(e),
        error: e,
      );
    } catch (e) {
      return ApiResponse.failure(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Retrieve all landmarks (GET)
  Future<ApiResponse<List<Landmark>>> getAllLandmarks() async {
    try {
      final response = await _dio.get(apiEndpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is List) {
          final landmarks = data
              .map((json) => Landmark.fromJson(json as Map<String, dynamic>))
              .toList();
          
          return ApiResponse.success(
            data: landmarks,
            message: 'Landmarks retrieved successfully',
          );
        }
        
        return ApiResponse.success(
          data: [],
          message: 'No landmarks found',
        );
      }

      return ApiResponse.failure(
        message: 'Failed to retrieve landmarks',
      );
    } on DioException catch (e) {
      return ApiResponse.failure(
        message: _handleError(e),
        error: e,
      );
    } catch (e) {
      return ApiResponse.failure(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Update an existing landmark (PUT)
  Future<ApiResponse<Landmark>> updateLandmark({
    required int id,
    required String title,
    required double latitude,
    required double longitude,
    File? imageFile,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
        'title': title,
        'lat': latitude,
        'lon': longitude,
      };

      FormData? formData;
      if (imageFile != null) {
        formData = FormData.fromMap({
          ...data,
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        });
      }

      final response = await _dio.put(
        apiEndpoint,
        data: formData ?? data,
        options: Options(
          contentType: imageFile != null 
              ? 'multipart/form-data' 
              : 'application/x-www-form-urlencoded',
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          message: 'Landmark updated successfully',
        );
      }

      return ApiResponse.failure(
        message: 'Failed to update landmark',
      );
    } on DioException catch (e) {
      return ApiResponse.failure(
        message: _handleError(e),
        error: e,
      );
    } catch (e) {
      return ApiResponse.failure(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Delete a landmark (DELETE)
  Future<ApiResponse<void>> deleteLandmark(int id) async {
    try {
      final response = await _dio.delete(
        '$apiEndpoint?id=$id',
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          message: 'Landmark deleted successfully',
        );
      }

      return ApiResponse.failure(
        message: 'Failed to delete landmark',
      );
    } on DioException catch (e) {
      return ApiResponse.failure(
        message: _handleError(e),
        error: e,
      );
    } catch (e) {
      return ApiResponse.failure(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Handle DioException errors
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      
      case DioExceptionType.cancel:
        return 'Request cancelled';
      
      case DioExceptionType.connectionError:
        return 'No internet connection';
      
      default:
        return 'Network error occurred';
    }
  }

  /// Check network connectivity
  Future<bool> checkConnectivity() async {
    try {
      final response = await _dio.get(
        apiEndpoint,
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
