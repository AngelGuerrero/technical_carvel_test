class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message ${statusCode != null ? '(Status: $statusCode)' : ''}';
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'Network error occurred']);
}

class ServerException extends ApiException {
  ServerException([super.message = 'Server error occurred', super.statusCode]);
}

class CacheException extends ApiException {
  CacheException([super.message = 'Cache error occurred']);
}

class TimeoutException extends ApiException {
  TimeoutException([super.message = 'Request timeout']);
}

