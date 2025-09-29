import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workout_provider.dart';
import 'router/app_router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutProvider()..loadState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    return MaterialApp.router(
      routerConfig: router,
      title: 'Workout App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: provider.darkMode ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: provider.darkMode ? Brightness.dark : Brightness.light,
        ),
        scaffoldBackgroundColor: provider.darkMode
            ? const Color.fromARGB(255, 0, 0, 0)
            : null,
        appBarTheme: AppBarTheme(
          backgroundColor: provider.darkMode
              ? const Color.fromARGB(255, 0, 0, 0)
              : null,
        ),
        cardTheme: CardThemeData(
          color: provider.darkMode ? Colors.grey[800] : Colors.grey[100],
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
