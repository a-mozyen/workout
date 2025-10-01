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
    final sex = provider.personalInfo?.sex;
    final bool isFemale = sex == 'female';
    return MaterialApp.router(
      routerConfig: router,
      title: 'Workout App',
      theme: ThemeData(
        useMaterial3: true,
        // Always use dark theme; remove light theme
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          // Deep purple accents for female, blueGrey otherwise
          seedColor: isFemale ? Colors.deepPurple : Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        // Keep background and app bar black for all (including female)
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ),
        cardTheme: CardThemeData(
          color: Colors.grey[800],
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
