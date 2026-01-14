import 'package:get/get.dart';
import 'collection_repo.dart';


class CollectionsController extends GetxController {
  final CollectionsRepo _repo;
  CollectionsController(this._repo);

  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> collections = <Map<String, dynamic>>[].obs;

  // Currently open collection
  RxInt activeCollectionId = 0.obs;
  RxString activeCollectionName = "".obs;

  // Quotes of active collection (SINGLE SOURCE OF TRUTH)
  RxList<Map<String, dynamic>> collectionQuotes = <Map<String, dynamic>>[].obs;
  RxBool isQuotesLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCollections();
  }

  // ---------------- COLLECTIONS ----------------

  Future<void> loadCollections() async {
    try {
      isLoading.value = true;
      collections.assignAll(await _repo.getCollections());
    } finally {
      isLoading.value = false;
    }
  }

  void goBackToCollections() {
    activeCollectionId.value = 0;
    collectionQuotes.clear();
  }


  Future<void> createCollection(String name) async {
    await _repo.createCollection(name);
    await loadCollections();
  }

  Future<void> deleteCollection(int id) async {
    await _repo.deleteCollection(id);

    // If deleting the active collection, clear UI state
    if (activeCollectionId.value == id) {
      activeCollectionId.value = 0;
      activeCollectionName.value = "";
      collectionQuotes.clear();
      Get.back(); // leave detail page
    }

    await loadCollections();
  }

  // ---------------- OPEN COLLECTION ----------------

  Future<void> openCollection(int id, String name) async {
    try {
      activeCollectionId.value = id;
      activeCollectionName.value = name;
      isQuotesLoading.value = true;

      final data = await _repo.getQuotes(id);
      collectionQuotes.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isQuotesLoading.value = false;
    }
  }


  // ---------------- QUOTES ----------------

  Future<void> refreshQuotes() async {
    if (activeCollectionId.value == 0) return;
    final data = await _repo.getQuotes(activeCollectionId.value);
    collectionQuotes.assignAll(data);
  }

  Future<void> addQuoteToCollection({
    required String quote,
    required String author,
  }) async {
    final id = activeCollectionId.value;
    if (id == 0) return;

    await _repo.addQuote(
      collectionId: id,
      quote: quote,
      author: author,
    );

    await refreshQuotes();
  }

  Future<void> removeQuoteFromCollection(String quote) async {
    final id = activeCollectionId.value;
    if (id == 0) return;

    await _repo.removeQuote(
      collectionId: id,
      quote: quote,
    );

    await refreshQuotes();
  }
}

