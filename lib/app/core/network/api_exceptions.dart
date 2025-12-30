import 'package:dio/dio.dart';

/// Base class for all API exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (statusCode: $statusCode)';
}

/// Exception for network-related errors (no internet, timeout, etc.)
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'Network error. Please check your internet connection.',
    super.statusCode,
  });
}

/// Exception for server errors (5xx status codes)
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.statusCode,
  });
}

/// Exception for unauthorized access (401 status code)
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Session expired. Please login again.',
    super.statusCode = 401,
  });
}

/// Exception for forbidden access (403 status code)
class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'You do not have permission to access this resource.',
    super.statusCode = 403,
  });
}

/// Exception for not found errors (404 status code)
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
  });
}

/// Exception for validation errors (422 status code)
class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation error. Please check your input.',
    super.statusCode = 422,
    this.errors,
  });
}

/// Exception for request timeout
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
  });
}

/// Exception for cancelled requests
class CancelledException extends ApiException {
  const CancelledException({
    super.message = 'Request was cancelled.',
    super.statusCode,
  });
}

/// Utility class for handling DioExceptions and converting them to ApiExceptions
class ApiExceptionHandler {
  static ApiException handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.cancel:
        return const CancelledException();

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception.response);

      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'Certificate verification failed.',
        );

      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: exception.message ?? 'An unexpected error occurred.',
        );
    }
  }

  static ApiException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    switch (statusCode) {
      case 400:
        return ApiException(
          message: _extractMessage(data) ?? 'Bad request.',
          statusCode: 400,
          data: data,
        );

      case 401:
        return const UnauthorizedException();

      case 403:
        return const ForbiddenException();

      case 404:
        return const NotFoundException();

      case 422:
        return ValidationException(
          message: _extractMessage(data) ?? 'Validation error.',
          errors: _extractValidationErrors(data),
        );

      case 429:
        return const ApiException(
          message: 'Too many requests. Please try again later.',
          statusCode: 429,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(statusCode: statusCode);

      default:
        return ApiException(
          message: _extractMessage(data) ?? 'An unexpected error occurred.',
          statusCode: statusCode,
          data: data,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String?;
    }
    if (data is String) return data;
    return null;
  }

  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return null;
    final errors = data['errors'];
    if (errors == null || errors is! Map<String, dynamic>) return null;
    
    return errors.map((key, value) {
      if (value is List) {
        return MapEntry(key, value.cast<String>());
      }
      return MapEntry(key, [value.toString()]);
    });
  }
}
