import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/auth_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'package:mahsoul_dz/core/services/fcm_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  // Login method
  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final response = await _authRepository.login(email, password);
      final user = response['user'] as Map<String, dynamic>;
      final userId = user['id'] as String;
      
      // Register FCM token after successful login
      try {
        await FCMService().registerToken(userId);
      } catch (e) {
        print('⚠️ Failed to register FCM token after login: $e');
        // Don't fail login if FCM registration fails
      }
      
      emit(AuthAuthenticated(
        userId: userId,
        userType: user['user_type'] as String,
      ));
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  // Signup method
  Future<void> signup({
    required String email,
    required String password,
    required String userType,
    String? fullName,
    required String phoneNumber,
  }) async {
    emit(AuthLoading());

    try {
      final response = await _authRepository.signup(
        email: email,
        password: password,
        userType: userType,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      
      final user = response['user'] as Map<String, dynamic>;
      final userId = user['id'] as String;
      
      // Register FCM token after successful signup
      try {
        await FCMService().registerToken(userId);
      } catch (e) {
        print('⚠️ Failed to register FCM token after signup: $e');
        // Don't fail signup if FCM registration fails
      }
      
      emit(AuthAuthenticated(
        userId: userId,
        userType: user['user_type'] as String,
      ));
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Signup failed: ${e.toString()}'));
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Get current user ID before logout
      final currentState = state;
      String? userId;
      if (currentState is AuthAuthenticated) {
        userId = currentState.userId;
      }
      
      await _authRepository.logout();
      
      // Unregister FCM token after logout
      if (userId != null) {
        try {
          await FCMService().unregisterToken(userId);
        } catch (e) {
          print('⚠️ Failed to unregister FCM token after logout: $e');
          // Don't fail logout if FCM unregistration fails
        }
      }
      
      emit(AuthUnauthenticated());
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  // Check if user is authenticated
  Future<void> checkAuthStatus() async {
    emit(AuthUnauthenticated());
  }
}



