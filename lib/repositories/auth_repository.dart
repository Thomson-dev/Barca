import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository(this.supabase);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return supabase.auth.signUp(
      email: email,
      password: password,
      data: {'first_name': firstName, 'last_name': lastName},
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return supabase.auth.signOut();
  }

  Future<Session?> restoreSession() {
    return supabase.auth.getSession();
  }

  Future<Session?> refreshAccessToken() async {
    final response = await supabase.auth.refreshSession();
    return response.session;
  }

  User? get currentUser {
    return supabase.auth.currentUser;
  }

  Stream<AuthState> get authStateChanges {
    return supabase.auth.onAuthStateChange;
  }
}
