import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenwords/core/theme/app_colours.dart';
import 'package:zenwords/core/theme/theme_controller.dart';
import 'package:zenwords/screens/dashboard/dashboard_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardController>();
    final theme = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor:
      theme.isDark.value ? AppColors.darkBg : AppColors.softPink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Account",
          style: GoogleFonts.bubblegumSans(
            fontSize: 28,
            color: theme.isDark.value
                ? AppColors.darkText
                : AppColors.heartPink,
          ),
        ),
        centerTitle: true,
      ),
      body: c.isLoading.value
          ? Center(
          child: CircularProgressIndicator(
              color: theme.isDark.value
                  ? AppColors.cloudWhite
                  : AppColors.heartPink))
          : ListView(
        padding: const EdgeInsets.all(24),
        children: [

          // EMAIL
          _settingCard(
            theme,
            title: "Email",
            subtitle: c.userEmail.value,
            icon: Icons.email,
            onTap: () => _showChangeEmailDialog(c),
          ),

          const SizedBox(height: 16),

          // PASSWORD
          _settingCard(
            theme,
            title: "Change Password",
            subtitle: "••••••••",
            icon: Icons.lock,
            onTap: () => _showChangePasswordDialog(c),
          ),

          const SizedBox(height: 32),

          // LOGOUT
          _dangerCard(
            theme,
            title: "Logout",
            icon: Icons.logout,
            onTap: c.logout,
          ),

          const SizedBox(height: 16),

          // DELETE ACCOUNT
          _dangerCard(
            theme,
            title: "Delete Account",
            icon: Icons.delete_forever,
            onTap: () => _confirmDelete(c),
          ),
        ],
      ),
    ));
  }

  // ==============================
  // UI CARDS
  // ==============================

  Widget _settingCard(
      ThemeController theme, {
        required String title,
        required String subtitle,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.isDark.value
              ? AppColors.darkCard
              : AppColors.textLight,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.heartPink),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.quicksand(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: theme.isDark.value
                              ? Colors.grey[400]
                              : Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _dangerCard(
      ThemeController theme, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.isDark.value
              ? AppColors.darkCard
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.redAccent),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.redAccent),
            const SizedBox(width: 16),
            Text(title,
                style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent)),
          ],
        ),
      ),
    );
  }

  // ==============================
  // DIALOGS
  // ==============================

  void _showChangeEmailDialog(DashboardController c) {
    final ctrl = TextEditingController(text: c.userEmail.value);

    Get.dialog(AlertDialog(
      title: const Text("Change Email"),
      content: TextField(controller: ctrl),
      actions: [
        TextButton(onPressed: Get.back, child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            c.changeEmail(ctrl.text.trim());
            Get.back();
          },
          child: const Text("Save"),
        ),
      ],
    ));
  }

  void _showChangePasswordDialog(DashboardController c) {
    final ctrl = TextEditingController();

    Get.dialog(AlertDialog(
      title: const Text("Change Password"),
      content: TextField(
        controller: ctrl,
        obscureText: true,
      ),
      actions: [
        TextButton(onPressed: Get.back, child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            c.changePassword(ctrl.text.trim());
            Get.back();
          },
          child: const Text("Update"),
        ),
      ],
    ));
  }

  void _confirmDelete(DashboardController c) {
    Get.dialog(AlertDialog(
      title: const Text("Delete Account"),
      content:
      const Text("This will permanently delete your account. Are you sure?"),
      actions: [
        TextButton(onPressed: Get.back, child: const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            c.deleteAccount();
            Get.back();
          },
          child: const Text("Delete"),
        ),
      ],
    ));
  }

}
