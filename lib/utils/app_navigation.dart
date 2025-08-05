import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pgagi_assign/models/startup_idea.dart';
import 'package:pgagi_assign/screens/idea_detail_screen.dart';
import 'package:pgagi_assign/screens/ideas_list_screen.dart';
import 'package:pgagi_assign/screens/leaderboard_screen.dart';
import 'package:pgagi_assign/screens/main_navigation_screen.dart';
import 'package:pgagi_assign/screens/splash_screen.dart';
import 'package:pgagi_assign/screens/submit_idea_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String submit = '/submit';
  static const String ideas = '/ideas';
  static const String leaderboard = '/leaderboard';
  static const String ideaDetail = '/idea/:id';
}

class AppNavigation {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.submit,
            name: 'submit',
            builder: (context, state) => const SubmitIdeaScreen(),
          ),

          GoRoute(
            path: AppRoutes.ideas,
            name: 'ideas',
            builder: (context, state) => const IdeasListScreen(),
          ),

          GoRoute(
            path: AppRoutes.leaderboard,
            name: 'leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        redirect: (context, state) => AppRoutes.ideas,
      ),

      GoRoute(
        path: '/idea/:id',
        name: 'ideaDetail',
        builder: (context, state) {
          final ideaId = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;
          final idea = extra?['idea'] as StartupIdea?;
          final rank = extra?['rank'] as int?;

          return IdeaDetailScreen(ideaId: ideaId, idea: idea, rank: rank);
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );

  static GoRouter get router => _router;

  static void goToSplash() {
    _router.go(AppRoutes.splash);
  }

  static void goToHome() {
    _router.go(AppRoutes.ideas);
  }

  static void goToSubmit() {
    _router.go(AppRoutes.submit);
  }

  static void goToIdeas() {
    _router.go(AppRoutes.ideas);
  }

  static void goToLeaderboard() {
    _router.go(AppRoutes.leaderboard);
  }

  static void goToIdeaDetail(String ideaId, {StartupIdea? idea, int? rank}) {
    _router.push(
      '/idea/$ideaId',
      extra: {if (idea != null) 'idea': idea, if (rank != null) 'rank': rank},
    );
  }

  static void goBack() {
    _router.pop();
  }

  static bool canPop() {
    return _router.canPop();
  }

  static void switchTab(int index) {
    switch (index) {
      case 0:
        goToSubmit();
        break;
      case 1:
        goToIdeas();
        break;
      case 2:
        goToLeaderboard();
        break;
    }
  }

  static int getCurrentTabIndex(String location) {
    if (location.startsWith(AppRoutes.submit)) return 0;
    if (location.startsWith(AppRoutes.ideas)) return 1;
    if (location.startsWith(AppRoutes.leaderboard)) return 2;
    return 1; // Default to ideas tab
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Oops! Page not found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppNavigation.goToHome(),
        label: const Text('Go Home'),
        icon: const Icon(Icons.home),
      ),
    );
  }
}
