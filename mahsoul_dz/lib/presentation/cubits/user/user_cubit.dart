import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/auth_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository _authRepository;

  UserCubit(this._authRepository) : super(UserInitial());

  // Load current user by ID
  Future<void> loadCurrentUser(String userId) async {
    emit(UserLoading());

    try {
      final response = await _authRepository.getCurrentUser(userId);
      final user = response['user'] as Map<String, dynamic>;
      emit(UserLoaded(user));
    } on ApiException catch (e) {
      emit(UserError(e.message));
    } catch (e) {
      emit(UserError('Failed to load user: ${e.toString()}'));
    }
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      // User updates should go through ProfileRepository
      // For now, just reload the user
      await loadCurrentUser(userId);
    } catch (e) {
      emit(UserError('Failed to update user: ${e.toString()}'));
    }
  }
}



