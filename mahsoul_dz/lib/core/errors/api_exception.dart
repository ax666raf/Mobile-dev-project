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
  NetworkException(super.message, {super.statusCode, super.originalError});
}

class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode, super.originalError});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {super.statusCode, super.originalError});
}

class NotFoundException extends ApiException {
  NotFoundException(super.message, {super.statusCode, super.originalError});
}

