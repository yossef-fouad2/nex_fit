import 'package:fpdart/fpdart.dart';
import '../utils/utils.dart';
import '../config/app_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool get _isConfigured => AppConfig.isSupabaseConfigured;
  SupabaseClient get _supabaseClient => AppConfig.supabase;

  /// Stream of auth state changes. Emits the current user map or null.
  Stream<Map<String, dynamic>?> get authStateChanges {
    if (!_isConfigured) return const Stream.empty();
    try {
      return _supabaseClient.auth.onAuthStateChange.map((data) {
        final session = data.session;
        if (session == null) return null;
        final user = session.user;
        return {
          'id': user.id,
          'email': user.email,
          'name': user.userMetadata?['name'] ?? '',
          'photoUrl': user.userMetadata?['avatar_url'],
        };
      }).handleError((_) => null);
    } catch (_) {
      return const Stream.empty();
    }
  }

  FutureEither<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    if (!_isConfigured) {
      return left(const ServerFailure('Supabase is not configured. Update .env with real credentials.'));
    }
    return runTask(() async {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) return null;
      return {
        'id': user.id,
        'email': user.email,
        'name': user.userMetadata?['name'] ?? '',
        'photoUrl': user.userMetadata?['avatar_url'],
      };
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!_isConfigured) {
      return left(const ServerFailure('Supabase is not configured. Update .env with real credentials.'));
    }
    return runTask(() async {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      final user = response.user;
      if (user == null) return null;
      return {
        'id': user.id,
        'email': user.email,
        'name': name,
        'photoUrl': user.userMetadata?['avatar_url'],
      };
    }, requiresNetwork: true);
  }

  FutureEither<void> forgotPassword({required String email}) async {
    if (!_isConfigured) {
      return left(const ServerFailure('Supabase is not configured. Update .env with real credentials.'));
    }
    return runTask(() async {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    }, requiresNetwork: true);
  }

  FutureEither<void> logout() async {
    if (!_isConfigured) return right(null);
    return runTask(() async {
      await _supabaseClient.auth.signOut();
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> getCurrentUser() async {
    if (!_isConfigured) return right(null);
    return runTask(() async {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) return null;
      final user = session.user;
      return {
        'id': user.id,
        'email': user.email,
        'name': user.userMetadata?['name'] ?? '',
        'photoUrl': user.userMetadata?['avatar_url'],
      };
    });
  }

  void dispose() {
    // Supabase manages its own streams
  }
}
