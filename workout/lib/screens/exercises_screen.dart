import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models.dart';
import '../workout_provider.dart';

class ExercisesScreen extends StatelessWidget {
  final String muscleId;
  const ExercisesScreen({super.key, required this.muscleId});

  @override
  Widget build(BuildContext context) {
    final filteredExercises = exercises
        .where((exercise) => exercise.muscleId == muscleId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Exercises')),
      body: filteredExercises.isEmpty
          ? const Center(child: Text('No exercises found for this muscle.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        exercise.imagepath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      exercise.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        _showAddExerciseDialog(context, exercise);
                      },
                      tooltip: 'Add to workout',
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddExerciseDialog(BuildContext context, Exercise exercise) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    String selectedDay = days.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text('Add ${exercise.name} to...'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButtonFormField<String>(
                initialValue: selectedDay,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: days.map((String day) {
                  return DropdownMenuItem<String>(value: day, child: Text(day));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedDay = newValue!;
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Add',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () {
                Provider.of<WorkoutProvider>(
                  context,
                  listen: false,
                ).addExercise(selectedDay, exercise);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green[700],
                    content: Text('Added ${exercise.name} to $selectedDay.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
