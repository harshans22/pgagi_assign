import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgagi_assign/blocs/startup_bloc.dart';
import 'package:pgagi_assign/blocs/theme_bloc.dart';
import 'package:pgagi_assign/constants/app_theme.dart';
import 'package:pgagi_assign/repositories/startup_repository.dart';
import 'package:pgagi_assign/services/storage_service.dart';
import 'package:pgagi_assign/utils/app_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storageService = await StorageService.getInstance();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StorageService>.value(value: storageService),
        RepositoryProvider<StartupRepository>(
          create:
              (context) => StartupRepository(context.read<StorageService>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create:
                (context) =>
                    ThemeBloc(context.read<StorageService>())..add(LoadTheme()),
          ),
          BlocProvider<StartupBloc>(
            create: (context) => StartupBloc(context.read<StartupRepository>()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final isDarkMode = state is ThemeLoaded ? state.isDarkMode : false;

            return ScreenUtilInit(
              designSize: const Size(375, 812), // iPhone 11 Pro design size
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp.router(
                  title: 'StartupHub',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  routerConfig: AppNavigation.router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
