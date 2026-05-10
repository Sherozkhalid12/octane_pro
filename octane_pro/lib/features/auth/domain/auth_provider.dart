import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/data/mock_data.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => user != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final users = MockData.getUsers();
    final user = users.firstWhere(
      (u) => u['username'] == username || u['email'] == username,
      orElse: () => <String, dynamic>{},
    );

    if (user.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid username or password',
      );
      return false;
    }

    // For demo, accept any password
    state = state.copyWith(
      user: UserModel(
        id: user['id'] as String,
        username: user['username'] as String,
        email: user['email'] as String,
        fullName: user['fullName'] as String?,
        role: UserRole.fromString(user['role'] as String),
        isActive: user['isActive'] as bool,
        createdAt: DateTime.now(),
      ),
      isLoading: false,
    );
    return true;
  }

  Future<void> logout() async {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
