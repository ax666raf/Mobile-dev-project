import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/auth_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
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
      
      emit(AuthAuthenticated(
        userId: user['id'] as String,
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
    String? phoneNumber,
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
      emit(AuthAuthenticated(
        userId: user['id'] as String,
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
      await _authRepository.logout();
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



