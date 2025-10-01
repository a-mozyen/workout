import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models.dart';
import '../workout_provider.dart';

class ExercisesScreen extends StatelessWidget {
  final String muscleGroupId;
  const ExercisesScreen({super.key, required this.muscleGroupId});

  @override
  Widget build(BuildContext context) {
    final musclesInGroup = muscles
        .where((m) => m.muscleGroupId == muscleGroupId)
        .toList();
    final muscleIdsInGroup = musclesInGroup.map((m) => m.id).toSet();
    final filteredExercises = exercises
        .where((e) => muscleIdsInGroup.contains(e.muscleId))
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
                      child: exercise.imagepath.isNotEmpty
                          ? Image.asset(
                              exercise.imagepath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white54,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image,
                                color: Colors.white54,
                              ),
                            ),
                    ),
                    title: Text(
                      exercise.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Muscles: ${musclesInGroup.where((m) => m.id == exercise.muscleId).map((m) => m.name).join(', ')}',
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
