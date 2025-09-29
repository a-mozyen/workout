import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';

class MuscleGroupsScreen extends StatelessWidget {
  const MuscleGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muscle Groups')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: muscleGroups.length,
        itemBuilder: (context, index) {
          final muscleGroup = muscleGroups[index];
          return GestureDetector(
            onTap: () => context.go('/add-workout/${muscleGroup.id}'),
            child: Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 300,
                    child: muscleGroup.imagepath.isNotEmpty
                        ? Image.asset(
                            muscleGroup.imagepath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.white54,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      muscleGroup.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
