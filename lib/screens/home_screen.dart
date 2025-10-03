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
    final provider = context.watch<WorkoutProvider>();
    final bool isFemale = provider.personalInfo?.sex == 'female';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Text(
          'Workout App'
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Personal Info'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/personal-info');
                },
              ),
              ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: const Text('Diet'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/diet');
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: StadiumBorder(),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        tooltip: 'Detect Device (AI)',
        onPressed: () => context.go('/detect-device'),
        child: Image.asset(
          'assets/icons/ai.png',
          color: Theme.of(context).colorScheme.primary,
          height: 30,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildNavigationCard(
              context,
              // 'Add Workout',
              _resolvedAsset(
                basePath: 'assets/images/home/add-workout.png',
                isFemale: isFemale,
              ),
              () => context.go('/add-workout'),
            ),
            const SizedBox(height: 30),
            _buildNavigationCard(
              context,
              // 'My Workouts',
              _resolvedAsset(
                basePath: 'assets/images/home/my-workout.png',
                isFemale: isFemale,
              ),
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
    final theme = Theme.of(context);
    final Color accent = theme.colorScheme.primary;
    final BorderRadius borderRadius = BorderRadius.circular(12);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 380,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: accent.withValues(alpha: 0.6),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      accent.withValues(alpha: 1.0),
                      BlendMode.hue,
                    ),
                    child: Image.asset(
                      imageUrl,
                      width: 400,
                      height: 300,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Returns a female-specific asset path if isFemale is true by inserting
  // "-female" before the file extension. Falls back to the base asset at
  // runtime if the female asset is missing using errorBuilder where used.
  String _femaleVariantPath(String basePath) {
    final dot = basePath.lastIndexOf('.');
    if (dot <= 0) return basePath;
    final name = basePath.substring(0, dot);
    final ext = basePath.substring(dot);
    return '$name-female$ext';
  }

  String _resolvedAsset({required String basePath, required bool isFemale}) {
    return isFemale ? _femaleVariantPath(basePath) : basePath;
  }
}
