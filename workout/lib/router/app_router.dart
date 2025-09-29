import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workout/screens/home_screen.dart';
import 'package:workout/screens/muscle_group_screen.dart';
import 'package:workout/screens/muscle_screen.dart';
import 'package:workout/screens/exercises_screen.dart';
import 'package:workout/screens/my_workout_screen.dart';
import 'package:workout/screens/device_detection_screen.dart';
import 'package:workout/screens/settings_screen.dart';
import 'package:workout/screens/personal_info_screen.dart';
import 'package:workout/screens/diet_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'add-workout',
          builder: (BuildContext context, GoRouterState state) {
            return const MuscleGroupsScreen();
          },
          routes: [
            GoRoute(
              path: ':muscleGroupId',
              builder: (BuildContext context, GoRouterState state) {
                final muscleGroupId = state.pathParameters['muscleGroupId']!;
                return MusclesScreen(muscleGroupId: muscleGroupId);
              },
              routes: [
                GoRoute(
                  path: ':muscleId',
                  builder: (BuildContext context, GoRouterState state) {
                    final muscleId = state.pathParameters['muscleId']!;
                    return ExercisesScreen(muscleId: muscleId);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'my-workouts',
          builder: (BuildContext context, GoRouterState state) {
            return const MyWorkoutsScreen();
          },
        ),
        GoRoute(
          path: 'detect-device',
          builder: (BuildContext context, GoRouterState state) {
            return const DeviceDetectionScreen();
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
          path: 'personal-info',
          builder: (BuildContext context, GoRouterState state) {
            return const PersonalInfoScreen();
          },
        ),
        GoRoute(
          path: 'diet',
          builder: (BuildContext context, GoRouterState state) {
            return const DietScreen();
          },
        ),
      ],
    ),
  ],
);
