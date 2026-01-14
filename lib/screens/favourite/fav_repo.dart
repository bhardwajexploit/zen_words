import 'package:zenwords/services/supabase_service.dart';

class FavoritesRepo {
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final user = SupabaseService.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final res = await SupabaseService.client
        .from('user_favorites')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> removeFavorite(String quote) async {
    final user = SupabaseService.currentUser;
    if (user == null) throw Exception("Not logged in");

    await SupabaseService.client
        .from('user_favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('quote', quote);
  }
}
