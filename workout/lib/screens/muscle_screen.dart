import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';

class MusclesScreen extends StatelessWidget {
  final String muscleGroupId;
  const MusclesScreen({super.key, required this.muscleGroupId});

  @override
  Widget build(BuildContext context) {
    final filteredMuscles = muscles
        .where((muscle) => muscle.muscleGroupId == muscleGroupId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Muscles')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: filteredMuscles.length,
        itemBuilder: (context, index) {
          final muscle = filteredMuscles[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  muscle.imagepath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                muscle.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () =>
                  context.go('/add-workout/$muscleGroupId/${muscle.id}'),
            ),
          );
        },
      ),
    );
  }
}
