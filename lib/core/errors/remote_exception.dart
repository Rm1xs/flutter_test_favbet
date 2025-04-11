import 'package:dio/dio.dart';

class RemoteException implements Exception {
  RemoteException({required this.message, this.statusCode, this.errorDetails});

  factory RemoteException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RemoteException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: null,
          errorDetails: e.message,
        );
      case DioExceptionType.badResponse:
        return RemoteException(
          message: _getHttpStatusMessage(e.response?.statusCode),
          statusCode: e.response?.statusCode,
          errorDetails: e.response?.data?.toString(),
        );
      case DioExceptionType.cancel:
        return RemoteException(
          message: 'Request was cancelled.',
          statusCode: null,
          errorDetails: e.message,
        );
      case DioExceptionType.connectionError:
        return RemoteException(
          message: 'Connection error. Unable to reach the server.',
          statusCode: null,
          errorDetails: e.message,
        );
      case DioExceptionType.badCertificate:
        return RemoteException(
          message: 'Invalid certificate. Security issue detected.',
          statusCode: null,
          errorDetails: e.message,
        );
      case DioExceptionType.unknown:
        return RemoteException(
          message: 'An unexpected error occurred.',
          statusCode: null,
          errorDetails: e.message,
        );
    }
  }

  final String message;
  final int? statusCode;
  final String? errorDetails;

  static String _getHttpStatusMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Invalid API key or credentials.';
      case 403:
        return 'Forbidden. You don’t have permission to access this resource.';
      case 404:
        return 'Not found. The requested resource does not exist.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Unknown error occurred (HTTP $statusCode).';
    }
  }

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'RemoteException: $message (Status: $statusCode, Details: $errorDetails)';
  }
}
