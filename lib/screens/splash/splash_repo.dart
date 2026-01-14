import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zenwords/services/supabase_service.dart';

class SplashRepo {
  SupabaseClient get _client => SupabaseService.client;

  /// ✅ Better session check
  Session? getCurrentSession() {
    final session = _client.auth.currentSession;
    return session?.user != null ? session : null;
  }

  bool hasSession() {
    return getCurrentSession() != null;
  }

  Stream<AuthState> authChanges() {
    return _client.auth.onAuthStateChange;
  }
}

