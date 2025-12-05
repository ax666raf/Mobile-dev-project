class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: $message (Status: $statusCode)';
    }
    return 'ApiException: $message';
  }
}

class NetworkException extends ApiException {
  NetworkException(String message, {int? statusCode, dynamic originalError})
      : super(message, statusCode: statusCode, originalError: originalError);
}

class ServerException extends ApiException {
  ServerException(String message, {int? statusCode, dynamic originalError})
      : super(message, statusCode: statusCode, originalError: originalError);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message, {int? statusCode, dynamic originalError})
      : super(message, statusCode: statusCode, originalError: originalError);
}

class NotFoundException extends ApiException {
  NotFoundException(String message, {int? statusCode, dynamic originalError})
      : super(message, statusCode: statusCode, originalError: originalError);
}

