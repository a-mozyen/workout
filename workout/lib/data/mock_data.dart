import '../models.dart';

const List<MuscleGroup> muscleGroups = [
  MuscleGroup(
    id: '1',
    name: 'Chest',
    imagepath: 'assets/images/muscle-group/chest.png',
  ),
  MuscleGroup(
    id: '2',
    name: 'Abdomen',
    imagepath: 'assets/images/muscle-group/abdomen.png',
  ),
  MuscleGroup(
    id: '3',
    name: 'Back',
    imagepath: 'assets/images/muscle-group/back.png',
  ),
  MuscleGroup(
    id: '4',
    name: 'Legs',
    imagepath: 'assets/images/muscle-group/legs.png',
  ),
  MuscleGroup(
    id: '5',
    name: 'Shoulders',
    imagepath: 'assets/images/muscle-group/shoulders.png',
  ),
  MuscleGroup(
    id: '6',
    name: 'Arms',
    imagepath: 'assets/images/muscle-group/arms.png',
  ),
];

const List<Muscle> muscles = [
  // Chest
  Muscle(id: '1', name: 'Pectoralis Major', imagepath: '', muscleGroupId: '1'),
  Muscle(id: '2', name: 'Pectoralis Minor', imagepath: '', muscleGroupId: '1'),
  // Back
  Muscle(id: '3', name: 'Latissimus Dorsi', imagepath: '', muscleGroupId: '2'),
  Muscle(id: '4', name: 'Trapezius', imagepath: '', muscleGroupId: '3'),
  // Legs
  Muscle(id: '5', name: 'Quadriceps', imagepath: '', muscleGroupId: '4'),
  Muscle(id: '6', name: 'Hamstrings', imagepath: '', muscleGroupId: '4'),
  // Shoulders
  Muscle(id: '7', name: 'Deltoids', imagepath: '', muscleGroupId: '5'),
  // Arms
  Muscle(id: '8', name: 'Biceps', imagepath: '', muscleGroupId: '6'),
  Muscle(id: '9', name: 'Triceps', imagepath: '', muscleGroupId: '6'),
];

const List<Exercise> exercises = [
  // Pectoralis Major
  Exercise(id: '1', name: 'Bench Press', imagepath: '', muscleId: '1'),
  Exercise(id: '2', name: 'Dumbbell Flyes', imagepath: '', muscleId: '1'),
  // Latissimus Dorsi
  Exercise(id: '3', name: 'Pull Ups', imagepath: '', muscleId: '3'),
  Exercise(id: '4', name: 'Bent Over Rows', imagepath: '', muscleId: '3'),
  // Quadriceps
  Exercise(id: '5', name: 'Squats', imagepath: '', muscleId: '5'),
  Exercise(id: '6', name: 'Leg Press', imagepath: '', muscleId: '5'),
];
