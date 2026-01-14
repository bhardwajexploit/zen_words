
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zenwords/model/quotes_model.dart';

import '../../services/supabase_service.dart';

class DashboardRepo {
  Future<List<QuotesModel>> getQuotes() async {
    final data = await SupabaseService.getQuotes();
    return data.map((e) => QuotesModel.fromJson(e)).toList();
  }

  Future<bool> isFavorite({
    required String quote,
  }) async {
    final user = SupabaseService.currentUser;
    if (user == null) return false;

    final res = await SupabaseService.client
        .from('user_favorites')
        .select('id')
        .eq('user_id', user.id)
        .eq('quote', quote)
        .maybeSingle();

    return res != null;
  }

  Future<void> addToFavorites({
    required String quote,
    required String author,
  }) async {
    final user = SupabaseService.currentUser;
    if (user == null) {
      throw Exception("Not logged in");
    }

    await SupabaseService.client.from('user_favorites').insert({
      'user_id': user.id,
      'quote': quote,
      'author': author,
    });
  }

  // ============================
  // COLLECTIONS (Dashboard side)
  // ============================

  Future<int> createCollection(String name) async {
    final user = SupabaseService.currentUser;
    if (user == null) throw Exception("Not logged in");

    final res = await SupabaseService.client
        .from('collections')
        .insert({
      'user_id': user.id,
      'name': name,
    })
        .select()
        .single();

    return res['id']; // return collection id for immediate use
  }

  // ============================
  // COLLECTION QUOTES
  // ============================

  Future<bool> isQuoteInCollection({
    required int collectionId,
    required String quote,
  }) async {
    final res = await SupabaseService.client
        .from('collection_quotes')
        .select('id')
        .eq('collection_id', collectionId)
        .eq('quote', quote)
        .maybeSingle();

    return res != null;
  }

  Future<void> addQuoteToCollection({
    required int collectionId,
    required String quote,
    required String author,
  }) async {
    final exists = await isQuoteInCollection(
      collectionId: collectionId,
      quote: quote,
    );

    if (exists) {
      throw Exception("Quote already exists in this collection");
    }

    await SupabaseService.client.from('collection_quotes').insert({
      'collection_id': collectionId,
      'quote': quote,
      'author': author,
    });
  }

  Future<List<Map<String, dynamic>>> getUserCollections() async {
    final user = SupabaseService.currentUser;
    if (user == null) {
      throw Exception("Not logged in");
    }

    final res = await SupabaseService.client
        .from('collections')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }
  Future<void> logout() async{
    try{
      await SupabaseService.logout();
    }catch (e){
      rethrow ;
    }
  }
  // ============================
// AUTH & ACCOUNT
// ============================

  Future<String> getUserEmail() async {
    final user = SupabaseService.currentUser;
    if (user == null) throw Exception("Not logged in");
    return user.email ?? "";
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(email: newEmail),
      );
    } catch (e) {
      throw Exception("Failed to update email");
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception("Failed to update password");
    }
  }

  Future<void> deleteAccount() async {
    final user = SupabaseService.currentUser;
    if (user == null) throw Exception("Not logged in");

    try {
      // Delete user data first
      await SupabaseService.client.from('user_favorites').delete().eq('user_id', user.id);
      await SupabaseService.client.from('collections').delete().eq('user_id', user.id);

      // Delete auth account
      await SupabaseService.client.rpc('delete_user');
    } catch (e) {
      throw Exception("Failed to delete account");
    }
  }



}
