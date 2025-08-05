import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pgagi_assign/blocs/theme_bloc.dart';
import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/utils/app_navigation.dart';

class MainNavigationScreen extends StatefulWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Submit',
      route: '/submit',
    ),
    NavItem(
      icon: Icons.lightbulb_outline,
      activeIcon: Icons.lightbulb,
      label: 'Ideas',
      route: '/ideas',
    ),
    NavItem(
      icon: Icons.emoji_events_outlined,
      activeIcon: Icons.emoji_events,
      label: 'Leaderboard',
      route: '/leaderboard',
    ),
  ];

  void _onItemTapped(int index) {
    AppNavigation.switchTab(index);
  }

  String _getScreenTitle(String location) {
    if (location.startsWith('/submit')) return 'Submit Idea';
    if (location.startsWith('/ideas')) return 'All Ideas';
    if (location.startsWith('/leaderboard')) return 'Leaderboard';
    return AppConstants.appName;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = AppNavigation.getCurrentTabIndex(location);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getScreenTitle(location),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Dark Mode Toggle
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              final isDark = state is ThemeLoaded ? state.isDarkMode : false;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
                tooltip:
                    isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              );
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items:
              _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == currentIndex;

                return BottomNavigationBarItem(
                  icon: AnimatedSwitcher(
                    duration: AppConstants.shortAnimationDuration,
                    child: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      key: ValueKey(isSelected),
                    ),
                  ).animate().scale(
                    duration: 200.ms,
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                  ),
                  label: item.label,
                );
              }).toList(),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
