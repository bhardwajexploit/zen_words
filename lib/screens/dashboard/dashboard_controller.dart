import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zenwords/model/quotes_model.dart';
import 'package:zenwords/screens/dashboard/dashboard_repo.dart';

import '../../core/theme/app_colours.dart';


enum ShareTemplate { soft, sunset, night }

class DashboardController extends GetxController {
  final DashboardRepo _repo;
  DashboardController(this._repo);

  @override
  void onInit() {
    super.onInit();
    getQuotes();
    loadUserProfile();
  }

  Rx<ShareTemplate> selectedTemplate = ShareTemplate.soft.obs;
  void showTemplatePicker(GlobalKey boundaryKey) {
    selectedTemplate.value = ShareTemplate.soft; // 🔥 reset on open

    Get.bottomSheet(
      Container(
        height: 260,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Style",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ShareTemplate.values.map((t) {
                  final selected = selectedTemplate.value == t;

                  return GestureDetector(
                    onTap: () => selectedTemplate.value = t,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 90,
                      height: 110,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.heartPink
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? AppColors.heartPink : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          t.name.toUpperCase(),
                          style: TextStyle(
                            color: selected ? AppColors.lavender : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.heartPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  Get.back();
                  await Future.delayed(const Duration(milliseconds: 120));
                  await WidgetsBinding.instance.endOfFrame;
                  shareQuoteImage(boundaryKey);
                },
                child: const Text(
                  "Share",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RxString userEmail = "".obs;

  // Tabs
  RxInt tabIndex = 0.obs;

  // Loading & Error
  RxBool isLoading = true.obs;
  RxString errorMsg = ''.obs;

  // Data
  RxList<QuotesModel> quotes = <QuotesModel>[].obs;
  RxList<QuotesModel> filteredQuotes = <QuotesModel>[].obs;
  Rx<QuotesModel?> currentQuote = Rx<QuotesModel?>(null);



  // UI
  RxBool isNewQuoteLoading = false.obs;

  void changeTab(int index) {
    tabIndex.value = index;
  }

  // ---------------- FETCH QUOTES ----------------

  Future<void> getQuotes() async {
    try {
      isLoading.value = true;

      final data = await _repo.getQuotes();
      quotes.assignAll(data);
      filteredQuotes.assignAll(data);

      if (quotes.isNotEmpty) {
        currentQuote.value = getQuoteOfTheDay();
      }
    } finally {
      isLoading.value = false;
    }
  }



  QuotesModel? getQuoteOfTheDay() {
    if (quotes.isEmpty) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final days = today.difference(DateTime(1970, 1, 1)).inDays;
    return quotes[days % quotes.length];
  }






  Future<void> getNewQuote() async {
    if (quotes.isEmpty) return;

    isNewQuoteLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // ✅ Simple: just pick ANY random quote
      final random = Random();
      currentQuote.value = quotes[random.nextInt(quotes.length)];
      debugPrint(currentQuote.value.toString());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isNewQuoteLoading.value = false;
    }
  }

  // ---------------- PULL TO REFRESH ----------------

  Future<void> refreshQuotes() async {
    await getQuotes();
  }

  // ---------------- SEARCH ----------------

  void selectedQuotes(String query) {
    if (query.isEmpty) {
      filteredQuotes.assignAll(quotes);
    } else {
      filteredQuotes.assignAll(
        quotes.where(
          (q) =>
              q.q.toLowerCase().contains(query.toLowerCase()) ||
              q.a.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> toggleFavorite(QuotesModel quote) async {
    try {
      final alreadyLiked = await _repo.isFavorite(quote: quote.q);

      if (alreadyLiked) {
        Get.snackbar(
          "Already Loved 💖",
          "Someone already liked this quote",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await _repo.addToFavorites(quote: quote.q, author: quote.a);

      Get.snackbar(
        "Saved 💕",
        "Quote added to favorites",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ===============================
  // COLLECTIONS (Dashboard Side)
  // ===============================

  RxInt selectedCollectionId = 0.obs;
  // ===============================
  // USER COLLECTIONS (for picker)
  // ===============================

  RxList<Map<String, dynamic>> collections = <Map<String, dynamic>>[].obs;
  RxBool isCollectionsLoading = false.obs;

  Future<void> loadCollections() async {
    try {
      isCollectionsLoading.value = true;

      final data = await _repo.getUserCollections();
      collections.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isCollectionsLoading.value = false;
    }
  }

  Future<void> createNewCollection(String name) async {
    try {
      final id = await _repo.createCollection(name);
      selectedCollectionId.value = id;
      Get.back(); // ✅ Close dialog FIRST
      Get.snackbar(
        "Collection Created",
        "✨ \"$name\" is ready to hold your favorite quotes!",
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // ===============================
  // ADD QUOTE TO COLLECTION
  // ===============================

  Future<void> addQuoteToCollection(QuotesModel quote) async {
    try {
      if (selectedCollectionId.value == 0) {
        Get.snackbar("No Collection", "Pick a collection first 💕");
        return;
      }

      await _repo.addQuoteToCollection(
        collectionId: selectedCollectionId.value,
        quote: quote.q,
        author: quote.a,
      );

      Get.snackbar("Saved", "💖 Quote added to your collection");
    } catch (e) {
      if (e.toString().contains("already")) {
        Get.snackbar("Already there", "Someone already saved this cutie 🥰");
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }
  // ===============================
  // COLLECTION DIALOGS
  // ===============================

  void showCreateCollectionDialog() {
    final nameCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("New Collection"),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(hintText: "e.g. Morning Vibes"),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isNotEmpty) {
                createNewCollection(name);
                Get.back();
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  Future<void> showAddToCollectionDialog(QuotesModel quote) async {
    await loadCollections(); // from previous step

    Get.bottomSheet(
      Container(
        height: 350,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          if (isCollectionsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (collections.isEmpty) {
            return const Center(child: Text("No collections yet"));
          }

          return Column(
            children: [
              const Text(
                "Add to Collection",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final col = collections[index];

                    return ListTile(
                      title: Text(col['name']),
                      onTap: () {
                        selectedCollectionId.value = col['id'];
                        addQuoteToCollection(quote);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _repo.logout();
      Get.offAllNamed("/welcome");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Load logged in user info
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      userEmail.value = await _repo.getUserEmail();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeEmail(String newEmail) async {
    try {
      isLoading.value = true;
      await _repo.updateEmail(newEmail);
      userEmail.value = newEmail;

      Get.snackbar("Updated 💕", "Your email has been changed");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(String password) async {
    try {
      isLoading.value = true;
      await _repo.updatePassword(password);
      Get.snackbar("Success 🔐", "Password updated");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      await _repo.deleteAccount();
      Get.offAllNamed('/login');

      Get.snackbar("Account Deleted 💔", "We will miss you");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareQuoteImage(GlobalKey boundaryKey) async {
    try {
      final boundary =
          boundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/quote.png');
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: "From ZenWords 💕"),
      );
    } catch (e) {
      Get.snackbar("Share failed", e.toString());
    }
  }
}
