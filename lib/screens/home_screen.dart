import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:workout/router/app_router.dart';
// import 'package:workout/screens/diet_screen.dart';
// import 'package:workout/screens/personal_info_screen.dart';
import '../workout_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _promptChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_promptChecked) {
      _promptChecked = true;
      final provider = context.read<WorkoutProvider>();
      if (!provider.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _maybePromptForPersonalInfo(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () => context.go('/settings'),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'WORKOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () {
                        context.go('');
                        //TODO: add account page path
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: [
                  _buildWorkoutTypeCard(
                    context,
                    'ADD WORKOUT',
                    'assets/images/home/add_workout.png',
                    () => context.go('/add-workout'),
                  ),
                  const SizedBox(height: 16),
                  _buildWorkoutTypeCard(
                    context,
                    'MY WORKOUTS',
                    'assets/images/home/my_workout.png',
                    () => context.go('/my-workouts'),
                  ),
                  const SizedBox(height: 16),
                  _buildWorkoutTypeCard(
                    context,
                    'DIET',
                    'assets/images/home/diet.png',
                    () => context.go('/diet'),
                  ),
                  const SizedBox(height: 16),
                  _buildWorkoutTypeCard(
                    context,
                    'PERSONAL INFO',
                    'assets/images/home/personal_info.png',
                    () => context.go('/personal-info'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => context.go('/detect-device'),
              child: const Text('AI DETECTION', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _maybePromptForPersonalInfo() {
    final provider = context.read<WorkoutProvider>();
    if (provider.hasCompletedOnboarding) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete your profile'),
        content: const Text(
          'To personalize workouts and diet, please enter your personal info.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/personal-info');
            },
            child: const Text('Enter now'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTypeCard(
    BuildContext context,
    String title,
    String imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
