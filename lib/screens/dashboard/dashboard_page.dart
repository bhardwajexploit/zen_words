import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenwords/core/theme/app_colours.dart';
import 'package:zenwords/screens/dashboard/dashboard_controller.dart';
import 'package:zenwords/screens/explore/explore_page.dart';
import 'package:zenwords/screens/home/home_page.dart';
import 'package:zenwords/screens/setting/setting_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController c = Get.find<DashboardController>();
    return Scaffold(
      body: SafeArea(
        child: Obx(() => IndexedStack(
          index: c.tabIndex.value,
          children: [
            HomePage(),
            const ExplorePage(),
            // Add Profile screen here for 3rd tab
            const SettingsPage(),
          ],
        )),
      ),
      bottomNavigationBar: Obx(() => Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: AppColors.heartPink.withValues(alpha: 0.15),

            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: AppColors.heartPink,
                  fontWeight: FontWeight.w600,
                );
              }
              return const TextStyle(color:AppColors.textDark);
            }),

            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: AppColors.heartPink);
              }
              return const IconThemeData(color: Colors.grey);
            }),
          ),
        ),
        child: NavigationBar(
          selectedIndex: c.tabIndex.value,
          onDestinationSelected: c.changeTab,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore),
              label: 'Browse',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      )),
    );
  }
}
