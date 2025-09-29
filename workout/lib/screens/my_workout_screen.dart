import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../workout_provider.dart';

class MyWorkoutsScreen extends StatelessWidget {
  const MyWorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Workouts'), centerTitle: true),

      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          final workouts = workoutProvider.workouts;
          if (workouts.isEmpty) {
            return const Center(
              child: Text(
                'No workouts added yet. Plan your week!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            );
          }
          final days = workouts.keys.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final exercises = workouts[day]!;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  children: exercises.map((exercise) {
                    final isDone = workoutProvider.isCompleted(
                      day,
                      exercise.id,
                    );
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: exercise.imagepath.isNotEmpty
                            ? Image.network(
                                exercise.imagepath,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[800],
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.white54,
                                      size: 24,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[800],
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white54,
                                  size: 24,
                                ),
                              ),
                      ),
                      title: Text(
                        exercise.name,
                        style: TextStyle(
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isDone,
                            onChanged: (value) {
                              workoutProvider.toggleCompletion(
                                day,
                                exercise.id,
                                value ?? false,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              workoutProvider.removeExercise(day, exercise);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red[700],
                                  content: Text(
                                    'Removed ${exercise.name} from $day.',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            tooltip: 'Remove exercise',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
