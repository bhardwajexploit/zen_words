import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenwords/core/theme/app_colours.dart';
import 'package:zenwords/core/theme/theme_controller.dart';
import 'fav_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final c = Get.find<FavoritesController>();

    return Obx(() => Scaffold(
      backgroundColor:
      theme.isDark.value ? AppColors.darkBg : AppColors.softPink,
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Favorites",
          style: GoogleFonts.bubblegumSans(
            fontSize: 28,
            color:
            theme.isDark.value ? AppColors.darkText : AppColors.heartPink,
          ),
        ),
        centerTitle: true,
      ),
      body: c.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : c.favorites.isEmpty
          ? Center(
        child: Text(
          "No favorites yet 💔",
          style: GoogleFonts.quicksand(
            fontSize: 18,
            color: theme.isDark.value
                ? AppColors.darkText
                : Colors.black,
          ),
        ),
      )
          : RefreshIndicator(
            onRefresh: () => c.loadFavorites(),
            child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: c.favorites.length,
                    itemBuilder: (context, index) {
            final fav = c.favorites[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.isDark.value
                    ? AppColors.darkCard
                    : AppColors.mint,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fav['quote'],
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.isDark.value
                          ? AppColors.darkText
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "— ${fav['author']}",
                        style: TextStyle(
                          color: theme.isDark.value
                              ? AppColors.darkText.withValues(alpha: .7)
                              : Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.pink),
                        onPressed: () {
                          c.remove(fav['quote']);
                        },
                      )
                    ],
                  )
                ],
              ),
            );
                    },
                  ),
          ),
    ));
  }
}
