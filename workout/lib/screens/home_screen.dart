import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _maybePromptForPersonalInfo(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).primaryColor,
        title: Image.asset(
          'assets/images/home/title.png',
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.color,
        ),
        centerTitle: true,
        leading: PopupMenuButton<String>(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu),
          onSelected: (value) {
            switch (value) {
              case 'settings':
                context.go('/settings');
                break;
              case 'personal_info':
                context.go('/personal-info');
                break;
              case 'diet':
                context.go('/diet');
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'settings', child: Text('Settings')),
            PopupMenuItem(value: 'personal_info', child: Text('Personal Info')),
            PopupMenuItem(value: 'diet', child: Text('Diet')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(),

        materialTapTargetSize: MaterialTapTargetSize.padded,
        tooltip: 'Detect Device (AI)',
        onPressed: () => context.go('/detect-device'),
        child: Image.asset(
          'assets/icons/ai.png',
          color: Theme.of(context).colorScheme.primary,
          height: 40,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildNavigationCard(
              context,
              // 'Add Workout',
              'assets/images/home/add-workout.png', // add workout image path
              () => context.go('/add-workout'),
            ),
            const SizedBox(height: 20),
            _buildNavigationCard(
              context,
              // 'My Workouts',
              'assets/images/home/my-workout.png', // my workout image path
              () => context.go('/my-workouts'),
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

  Widget _buildNavigationCard(
    BuildContext context,
    // String title,
    String imageUrl,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 400,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(imageUrl, width: 400, height: 400, fit: BoxFit.cover),
              // Container(width: 250, height: 250, color: Colors.black),
              // Text(
              //   title,
              //   style: const TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
