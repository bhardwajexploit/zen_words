import 'package:zenwords/services/supabase_service.dart';

class CollectionsRepo {
  Future<List<Map<String, dynamic>>> getCollections() {
    return SupabaseService.getCollections();
  }

  Future<void> createCollection(String name) {
    return SupabaseService.createCollection(name);
  }

  Future<void> deleteCollection(int id) {
    return SupabaseService.deleteCollection(id);
  }

  Future<List<Map<String, dynamic>>> getQuotes(int collectionId) {
    return SupabaseService.getCollectionQuotes(collectionId);
  }

  Future<void> addQuote({
    required int collectionId,
    required String quote,
    required String author,
  }) {
    return SupabaseService.addQuoteToCollection(
      collectionId: collectionId,
      quote: quote,
      author: author,
    );
  }

  Future<void> removeQuote({
    required int collectionId,
    required String quote,
  }) {
    return SupabaseService.removeQuoteFromCollection(
      collectionId: collectionId,
      quote: quote,
    );
  }
}
