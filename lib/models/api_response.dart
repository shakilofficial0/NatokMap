/// Model: API Response wrapper
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.success({T? data, String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message ?? 'Operation successful',
    );
  }

  factory ApiResponse.failure({String? message, dynamic error}) {
    return ApiResponse(
      success: false,
      message: message ?? 'Operation failed',
      error: error,
    );
  }
}
