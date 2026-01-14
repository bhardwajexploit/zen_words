import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenwords/core/theme/app_colours.dart';
import 'package:zenwords/core/theme/theme_controller.dart';
import 'package:zenwords/screens/dashboard/dashboard_controller.dart';

import '../../model/quotes_model.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardController>();
    final theme = Get.find<ThemeController>();

    return Obx(() => Scaffold(  // ✅ Move Obx to top level
      backgroundColor: theme.isDark.value ? AppColors.darkBg : AppColors.softPink,
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar - FIXED theme reactivity
          SliverAppBar(
            expandedHeight: 140,
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(start: 72, bottom: 16),
              centerTitle: false,
              title: Text(
                "Browse Quotes!",
                style: GoogleFonts.bubblegumSans(
                  fontSize: 24,
                  color: theme.isDark.value ? AppColors.darkText : AppColors.heartPink,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.isDark.value ? AppColors.darkBg : AppColors.softPink,
                      theme.isDark.value ? AppColors.darkCard : AppColors.lavender.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
            leading: InkWell(
              onTap: () => c.changeTab(0),
              child: _circleIcon(Icons.arrow_back),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => Get.toNamed('/fav'),
                      child: _circleIcon(Icons.favorite, filled: true),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => Get.toNamed('/collections'),
                      child: _circleIcon(Icons.folder),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Search Bar Sliver
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: _buildSearchBar(theme),  // ✅ This already handles theme
            ),
          ),

          // Quotes List Sliver - FIXED
          SliverToBoxAdapter(
            child: Obx(() {  // ✅ Single Obx for list
              final dark = theme.isDark.value ? AppColors.cloudWhite : AppColors.heartPink;

              if (c.isLoading.value) {
                return Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator(color: dark)),
                );
              }

              final list = c.filteredQuotes.isEmpty ? c.quotes : c.filteredQuotes;

              return RefreshIndicator(
                onRefresh: () => c.refreshQuotes(),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final quote = list[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCuteCard(quote.q, quote.a, index, theme),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    ));
  }

  // ---------------- HEADER ----------------


  // ---------------- SEARCH ----------------

  Widget _buildSearchBar(ThemeController theme) {
    final c = Get.find<DashboardController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: theme.isDark.value
              ? AppColors.darkCard
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.isDark.value ? Colors.white : Colors.black,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.pink),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                onChanged: (value) => c.selectedQuotes(value),
                style: TextStyle(
                  color:
                  theme.isDark.value ? AppColors.darkText : Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: "Find a cute quote...",
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- QUOTE CARD ----------------
  Widget _buildCuteCard(
      String quote,
      String author,
      int index,
      ThemeController theme,
      ) {
    final DashboardController c = Get.find<DashboardController>();

    final pastel = [
      AppColors.quoteBlue,
      AppColors.quotePink,
      AppColors.quoteYellow,
      AppColors.quoteGreen,
    ][index % 4];

    final q = QuotesModel(q: quote, a: author);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.isDark.value ? AppColors.darkCard : pastel,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: pastel, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              // ─────── THREE DOT MENU ───────
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert, size: 22, color: Colors.grey[600]),
                onSelected: (value) {
                  if (value == "add") {
                    c.showAddToCollectionDialog(q);
                  } else if (value == "create") {
                    c.showCreateCollectionDialog();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "add",
                    child: Row(
                      children: [
                        Icon(Icons.folder,
                            color: AppColors.heartPink, size: 20),
                        const SizedBox(width: 12),
                        const Text("Add to collection"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "create",
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline,
                            color: AppColors.heartPink, size: 20),
                        const SizedBox(width: 12),
                        const Text("Create new collection"),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 6),

              // ─────── HEART ───────
              InkWell(
                onTap: () => c.toggleFavorite(q),
                child: const CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: Icon(Icons.favorite, color: Colors.white),
                ),
              ),

              const SizedBox(width: 12),

              // ─────── QUOTE ───────
              Expanded(
                child: Text(
                  quote,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.isDark.value
                        ? AppColors.darkText
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "— $author",
            style: TextStyle(
              color: theme.isDark.value
                  ? AppColors.darkText.withValues(alpha: .7)
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }



  // ---------------- ICON ----------------

  Widget _circleIcon(IconData icon, {bool filled = false}) {
    return CircleAvatar(
      backgroundColor: filled ? Colors.pink : Colors.white,
      child: Icon(icon, color: filled ? Colors.white : Colors.pink),
    );
  }
}
