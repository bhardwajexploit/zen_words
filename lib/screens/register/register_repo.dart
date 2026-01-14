
import '../../services/supabase_service.dart';
class RegisterRepo {
  Future<void> register({
    required String email,
    required String password,
  }) async {
    try{
      await SupabaseService.register(
        email: email,
        password: password,
      );
    }catch (e){
      rethrow;
    }

  }
}
