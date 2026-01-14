import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static SupabaseClient get client => Supabase.instance.client;

  // ======================
  // INIT
  // ======================
  static Future<void> init() async {
    try {
      await Supabase.initialize(
        url: 'https://txhejouiklatmhemqqpx.supabase.co',
        anonKey: 'sb_publishable_G1C9vRxJaPGtcwvYsfUDig_jL5VAGzn',
        authOptions: const FlutterAuthClientOptions(
          autoRefreshToken: true,
          detectSessionInUri: false,
        ),
      );
    } catch (e) {
      throw Exception("Supabase init failed: $e");
    }
  }

  // ======================
  // AUTH
  // ======================

  static User? get currentUser => client.auth.currentUser;

  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      return await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Login failed");
    }
  }

  static Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      final res = await client.auth.signUp(
        email: email,
        password: password,
      );

      // 🔥 IMPORTANT: Kill auto-created session
      if (res.session != null) {
        await client.auth.signOut();
      }

    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Registration failed");
    }
  }


  static Future<void> logout() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception("Logout failed");
    }
  }

  // ======================
  // QUOTES
  // ======================

  static Future<List<Map<String, dynamic>>> getQuotes() async {
    try {
      final res = await client.from('quotes').select();
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      throw Exception("Failed to load quotes");
    }
  }

  // ======================
  // FAVORITES
  // ======================

  static Future<void> saveFavorite({
    required String quote,
    required String author,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      await client.from('favorites').insert({
        'user_id': user.id,
        'quote': quote,
        'author': author,
      });
    } catch (e) {
      throw Exception("Failed to save favorite");
    }
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final res = await client
          .from('favorites')
          .select()
          .eq('user_id', user.id);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      throw Exception("Failed to load favorites");
    }
  }
  // ======================
// USER FAVORITES (RLS)
// ======================

  static Future<void> addUserFavorite({
    required String quote,
    required String author,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception("Not logged in");

    await client.from('user_favorites').insert({
      'user_id': user.id,
      'quote': quote,
      'author': author,
    });
  }

  static Future<void> removeUserFavorite(String quote) async {
    final user = currentUser;
    if (user == null) throw Exception("Not logged in");

    await client
        .from('user_favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('quote', quote);
  }
  static Future<List<Map<String, dynamic>>> getUserFavorites() async {
    final user = currentUser;
    if (user == null) throw Exception("Not logged in");

    final res = await client
        .from('user_favorites')
        .select()
        .eq('user_id', user.id)
        .order('created_at');

    return List<Map<String, dynamic>>.from(res);
  }
  static Future<bool> isQuoteFavorited(String quote) async {
    final user = currentUser;
    if (user == null) return false;

    final res = await client
        .from('user_favorites')
        .select('id')
        .eq('user_id', user.id)
        .eq('quote', quote)
        .maybeSingle();

    return res != null;
  }
// ======================
// COLLECTIONS
// ======================

  static Future<void> createCollection(String name) async {
    final user = currentUser;
    if (user == null) throw Exception("Not logged in");

    await client.from('collections').insert({
      'user_id': user.id,
      'name': name,
    });
  }
  static Future<List<Map<String, dynamic>>> getCollections() async {
    final user = currentUser;
    if (user == null) throw Exception("Not logged in");

    final res = await client
        .from('collections')
        .select()
        .eq('user_id', user.id)
        .order('created_at');

    return List<Map<String, dynamic>>.from(res);
  }
  static Future<void> deleteCollection(int id) async {
    await client.from('collections').delete().eq('id', id);
  }
  // ======================
// COLLECTION QUOTES
// ======================

  static Future<void> addQuoteToCollection({
    required int collectionId,
    required String quote,
    required String author,
  }) async {
    await client.from('collection_quotes').insert({
      'collection_id': collectionId,
      'quote': quote,
      'author': author,
    });
  }
  static Future<void> removeQuoteFromCollection({
    required int collectionId,
    required String quote,
  }) async {
    await client
        .from('collection_quotes')
        .delete()
        .eq('collection_id', collectionId)
        .eq('quote', quote);
  }
  static Future<List<Map<String, dynamic>>> getCollectionQuotes(
      int collectionId,
      ) async {
    final res = await client
        .from('collection_quotes')
        .select()
        .eq('collection_id', collectionId);

    return List<Map<String, dynamic>>.from(res);
  }


}
