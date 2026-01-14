import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenwords/core/theme/theme_controller.dart';
import 'package:zenwords/screens/dashboard/dashboard_controller.dart';

import '../../core/theme/app_colours.dart';
import '../../model/quotes_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey _shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final ThemeController theme = Get.find<ThemeController>();
    return Obx(() {
     return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: theme.isDark.value ?
              [AppColors.darkBg, AppColors.darkBg]
              :[AppColors.softPink, AppColors.lavender],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(theme),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(ThemeController theme) {
    final c=Get.find<DashboardController>();
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              theme.toggleTheme();
            },
            icon: Icon(
              theme.isDark.value ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.heartPink,
            ),
          ),

          Text(
            'Zen Words',
            style: GoogleFonts.bubblegumSans(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: AppColors.textDark,
            ),
          ),
          _buildIconButton(Icons.logout, Color(0xFFFF8BA7), () {
            c.logout();
            Get.offAllNamed('/welcome');
          }),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }

  Widget _buildMainContent() {
    final c = Get.find<DashboardController>();

    return Stack(
      children: [
        ..._buildSparkles(),
        Positioned(top: 20, right: 32, child: _buildTypingIndicator()),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQuoteCard(),
              const SizedBox(height: 48),
              _buildNewQuoteButton(),
            ],
          ),
        ),

        // 🔥 THIS IS WHAT YOU WERE MISSING
        Positioned(
          left: -2000,
          top: -2000,
          child: Obx(() {
            final quote = c.currentQuote.value;
            if (quote == null) return const SizedBox();

            return RepaintBoundary(
              key: _shareKey,
              child: _buildShareCardUI(quote),
            );
          }),
        ),
      ],
    );
  }


  Widget _buildShareCardUI(QuotesModel quote) {
    final c = Get.find<DashboardController>();

    return Obx(() {
      final t = c.selectedTemplate.value;

      LinearGradient bg;
      Color text;

      switch (t) {
        case ShareTemplate.sunset:
          bg = const LinearGradient(
            colors: [Color(0xFFFF8BA7), Color(0xFFFFC0A0)],
          );
          text = Colors.white;
          break;

        case ShareTemplate.night:
          bg = const LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
          );
          text = Colors.white;
          break;

        default:
          bg = LinearGradient(
            colors: [AppColors.softPink, AppColors.lavender],
          );
          text = Colors.black87;
      }

      return Container(
        width: 600,
        height: 800,
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          gradient: bg,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "“${quote.q}”",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 42,
                height: 1.3,
                fontWeight: FontWeight.bold,
                color: text,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "— ${quote.a}",
              style: GoogleFonts.bubblegumSans(
                fontSize: 28,
                color: text.withValues(alpha: 0.9),
              ),
            ),
            const Spacer(),
            Text(
              "ZenWords",
              style: TextStyle(
                color: text.withValues(alpha: 0.7),
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuoteCard() {
    final c = Get.find<DashboardController>();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8BA7).withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Obx(() {
        // ⛔ Still loading OR no quote yet
        if (c.isLoading.value || c.currentQuote.value == null) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFFFF8BA7),
              ),
            ),
          );
        }

        final quote = c.currentQuote.value!;

        return Column(
          children: [
            Stack(
              children: [
                Positioned(
                  left: -8,
                  top: -16,
                  child: Icon(
                    Icons.format_quote,
                    size: 80,
                    color: const Color(0xFFFF8BA7).withValues(alpha: 0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    quote.q, // ✅ quote text
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5F4B66),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              "- ${quote.a}", // ✅ author
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 32),

            Column(
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDDE2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'SWEET REMINDER',
                  style: TextStyle(
                    color: Color(0xFFFF8BA7),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                _buildActionButton(
                    Icons.favorite,
                    const Color(0xFFFFDDE2),
                    const Color(0xFFFF8BA7),
                  onTap: () => c.toggleFavorite(quote),

                  ),
                const SizedBox(width: 16),
                _buildActionButton(
                  onTap: () => c.showTemplatePicker(_shareKey),
                  Icons.share,
                  const Color(0xFFE6E1F9),
                  const Color(0xFFA78BFF),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  Icons.content_copy,
                  const Color(0xFFDFF9F2),
                  const Color(0xFF7BDCB5),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionButton(IconData icon, Color bgColor, Color iconColor, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        splashColor: Colors.white24,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
      ),
    );
  }


  Widget _buildNewQuoteButton() {
    return Obx(() {
      final c = Get.find<DashboardController>();
      return GestureDetector(
        onTap: c.isNewQuoteLoading.value ? null : () => c.getNewQuote(),
        child: Container(
          constraints: BoxConstraints(minWidth: 220),
          height: 64,
          padding: EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(48),
            border: Border(
              bottom: BorderSide(color: Color(0xFFF9E8F0), width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (c.isNewQuoteLoading.value)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Color(0xFFFF8BA7)),
                  ),
                )
              else
                Icon(Icons.cached, color: Color(0xFFFF8BA7), size: 24),
              SizedBox(width: 12),
              Text(
                'New Quote',
                style: GoogleFonts.bubblegumSans(
                  fontSize: 20,
                  color: Color(0xFFFF8BA7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTypingIndicator() {
    return Container(
      width: 64,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xFF374151),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xFF374151),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: 12,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFFBB6CE),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  List<Positioned> _buildSparkles() {
    return [
      Positioned(
        top: 80,
        left: 40,
        child: Icon(
          Icons.color_lens,
          color: Color(0xFFFFD700).withValues(alpha: 0.6),
          size: 32,
        ),
      ),
      Positioned(
        top: 160,
        right: 48,
        child: Icon(
          Icons.color_lens,
          color: Color(0xFFFFD700).withValues(alpha: 0.4),
          size: 40,
        ),
      ),
      Positioned(
        bottom: 160,
        left: 64,
        child: Icon(
          Icons.color_lens,
          color: Color(0xFFFFD700).withValues(alpha: 0.5),
          size: 24,
        ),
      ),
    ];
  }
}