import 'package:get/get.dart';
import 'fav_repo.dart';

class FavoritesController extends GetxController {
  final FavoritesRepo _repo;
  FavoritesController(this._repo);

  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      final data = await _repo.getFavorites();
      favorites.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> remove(String quote) async {
    await _repo.removeFavorite(quote);
    favorites.removeWhere((e) => e['quote'] == quote);
  }
}
