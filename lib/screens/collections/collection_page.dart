import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenwords/core/theme/app_colours.dart';
import 'package:zenwords/core/theme/theme_controller.dart';
import 'collection_controller.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CollectionsController>();
    final theme = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor: theme.isDark.value ? AppColors.darkBg : AppColors.softPink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          c.activeCollectionId.value == 0
              ? "My Collections"
              : c.activeCollectionName.value,
          style: GoogleFonts.bubblegumSans(
            fontSize: 28,
            color: theme.isDark.value ? AppColors.darkText : AppColors.heartPink,
          ),
        ),
        centerTitle: true,
        leading: c.activeCollectionId.value == 0
            ? null
            : IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () {
            c.goBackToCollections();
          },
        ),
      ),
      floatingActionButton: c.activeCollectionId.value == 0
          ? FloatingActionButton(
        backgroundColor: AppColors.heartPink,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _showCreateDialog(c),
      )
          : null,
      body: c.isLoading.value
          ? Center(child: CircularProgressIndicator(color: theme.isDark.value ? AppColors.cloudWhite : AppColors.heartPink))
          : c.activeCollectionId.value == 0
          ? _buildCollectionsList(c, theme)
          : _buildCollectionQuotes(c, theme),
    ));
  }

  Widget _buildCollectionsList(CollectionsController c, ThemeController theme) {
    return RefreshIndicator(
      onRefresh: c.loadCollections,
      child: c.collections.isEmpty
          ? Center(child: Text("No collections yet\nTap + to create one", textAlign: TextAlign.center, style: TextStyle(color: theme.isDark.value ? AppColors.cloudWhite : Colors.grey)))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: c.collections.length,
        itemBuilder: (_, i) {
          final col = c.collections[i];
          return Material( // ✅ Ripple effect
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => c.openCollection(col['id'], col['name']),
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.isDark.value ? AppColors.darkCard : AppColors.quotePink,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(col['name'], style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.w600, color: theme.isDark.value ? AppColors.darkText : Colors.black)),
                          if (col['quoteCount'] != null)
                            Text("${col['quoteCount']} quotes", style: TextStyle(fontSize: 14, color: theme.isDark.value ? Colors.grey[400] : Colors.grey[600])),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.heartPink),
                      onPressed: () => c.deleteCollection(col['id']),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCollectionQuotes(CollectionsController c, ThemeController theme) {
    if (c.isQuotesLoading.value) {
      return Center(child: CircularProgressIndicator(color: theme.isDark.value ? AppColors.cloudWhite : AppColors.heartPink));
    }

    if (c.collectionQuotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text("No quotes yet", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            SizedBox(height: 8),
            Text("Add some beautiful quotes to this collection", style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: c.refreshQuotes,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: c.collectionQuotes.length,
        itemBuilder: (_, i) {
          final q = c.collectionQuotes[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {}, // Optional tap action
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.isDark.value ? AppColors.darkCard : AppColors.quoteBlue,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(q['quote'], style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.w600, color: theme.isDark.value ? AppColors.darkText : Colors.black)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text("— ${q['author']}", style: TextStyle(color: theme.isDark.value ? AppColors.darkText.withValues(alpha: .7) : Colors.black54)),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: AppColors.heartPink),
                          onPressed: () => c.removeQuoteFromCollection(q['quote']),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreateDialog(CollectionsController c) {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.isDarkMode ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Create Collection", style: GoogleFonts.bubblegumSans(fontSize: 20)),
        content: TextField(
          controller: ctrl,
          style: TextStyle(color: Get.isDarkMode ? AppColors.darkText : Colors.black),
          decoration: InputDecoration(
            hintText: "e.g. Morning Vibes 💕",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.heartPink),
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isNotEmpty) {
                c.createCollection(name);
                Get.back();
              }
            },
            child: Text("Create", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
