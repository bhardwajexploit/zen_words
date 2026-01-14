import '../../services/supabase_service.dart';

class LoginRepo {
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await SupabaseService.login(email: email, password: password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
