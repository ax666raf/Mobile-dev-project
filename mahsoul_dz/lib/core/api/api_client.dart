import 'package:dio/dio.dart'; //we used dio , an http clinet library to make api calls
import 'package:mahsoul_dz/core/config/api_config.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    final baseUrl = ApiConfig.baseUrl;
    print('🔧 ApiClient initialized with baseUrl: $baseUrl');
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request details for debugging
          print('📤 API Request: ${options.method} ${options.uri}');
          if (options.data != null) {
            print('📤 Request Body: ${options.data}');
          }
          if (options.queryParameters.isNotEmpty) {
            print('📤 Query Parameters: ${options.queryParameters}');
          }
          // Can add auth token here later 
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ API Response: ${response.statusCode} ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (error, handler) {
          // Handling errors and converting to ApiException
          final apiException = _handleError(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: apiException,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );
  }

  ApiException _handleError(DioException error) {
    
    print('❌ API Error Details:');
    print('   Type: ${error.type}');
    print('   Message: ${error.message}');
    print('   URL: ${error.requestOptions.uri}');
    print('   Base URL: ${error.requestOptions.baseUrl}');
    
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return NetworkException(
        'Connection timeout. Please check your internet connection.',
        statusCode: null,
        originalError: error,
      );
    }

    // Handling connection errors (connection refused, no internet, etc.)
    if (error.type == DioExceptionType.connectionError) {
      final baseUrl = error.requestOptions.baseUrl;
      return NetworkException(
        'Cannot connect to server at $baseUrl. Make sure the backend is running on port 5000.',
        statusCode: null,
        originalError: error,
      );
    }

    if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      final message = error.response?.data?['error'] ?? 
                     error.response?.data?['message'] ?? 
                     'Server error: $statusCode';

      if (statusCode == 401) {
        return UnauthorizedException(
          message,
          statusCode: statusCode,
          originalError: error,
        );
      }

      if (statusCode == 404) {
        return NotFoundException(
          message,
          statusCode: statusCode,
          originalError: error,
        );
      }

      if (statusCode != null && statusCode >= 500) {
        return ServerException(
          message,
          statusCode: statusCode,
          originalError: error,
        );
      }

      return ApiException(
        message,
        statusCode: statusCode,
        originalError: error,
      );
    }

    if (error.type == DioExceptionType.cancel) {
      return ApiException(
        'Request cancelled',
        originalError: error,
      );
    }

    // Catch-all for other connection errors (other errors)
    return NetworkException(
      'Network error: ${error.message ?? 'Unknown error'}. URL: ${error.requestOptions.uri}',
      statusCode: null,
      originalError: error,
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _handleError(e);
    }
  }
}

