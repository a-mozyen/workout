import 'package:flutter/material.dart';
import 'models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutProvider with ChangeNotifier {
  final Map<String, List<Exercise>> _workouts = {};
  // Tracks completed exercise ids per day
  final Map<String, Set<String>> _completedExercisesByDay = {};

  // App state additions
  PersonalInfo? _personalInfo;
  bool _hasCompletedOnboarding = false;
  bool _darkMode = true;
  String _languageCode = 'en';
  bool _isLoading = true;

  PersonalInfo? get personalInfo => _personalInfo;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get darkMode => _darkMode;
  String get languageCode => _languageCode;
  bool get isLoading => _isLoading;

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    _darkMode = prefs.getBool('darkMode') ?? true;
    _languageCode = prefs.getString('languageCode') ?? 'en';
    final height = prefs.getDouble('pi_heightCm');
    final weight = prefs.getDouble('pi_weightKg');
    final sex = prefs.getString('pi_sex');
    final age = prefs.getInt('pi_age');
    if (height != null && weight != null && sex != null && age != null) {
      _personalInfo = PersonalInfo(
        heightCm: height,
        weightKg: weight,
        sex: sex,
        age: age,
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setPersonalInfo(PersonalInfo info) async {
    _personalInfo = info;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('pi_heightCm', info.heightCm);
    await prefs.setDouble('pi_weightKg', info.weightKg);
    await prefs.setString('pi_sex', info.sex);
    await prefs.setInt('pi_age', info.age);
    await prefs.setBool('hasCompletedOnboarding', true);
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool enabled) async {
    _darkMode = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', enabled);
    notifyListeners();
  }

  Future<void> setLanguageCode(String code) async {
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
    notifyListeners();
  }

  Map<String, List<Exercise>> get workouts => _workouts;

  bool isCompleted(String day, String exerciseId) {
    return _completedExercisesByDay[day]?.contains(exerciseId) ?? false;
  }

  void toggleCompletion(String day, String exerciseId, bool completed) {
    final set = _completedExercisesByDay.putIfAbsent(day, () => <String>{});
    if (completed) {
      set.add(exerciseId);
    } else {
      set.remove(exerciseId);
    }
    notifyListeners();
  }

  void addExercise(String day, Exercise exercise) {
    if (_workouts.containsKey(day)) {
      _workouts[day]!.add(exercise);
    }
    else {
      _workouts[day] = [exercise];
    }
    notifyListeners();
  }

  void removeExercise(String day, Exercise exercise) {
    if (_workouts.containsKey(day)) {
      _workouts[day]!.remove(exercise);
      if (_workouts[day]!.isEmpty) {
        _workouts.remove(day);
        _completedExercisesByDay.remove(day);
      }
      else {
        // Also clear completion state for this exercise
        _completedExercisesByDay[day]?.remove(exercise.id);
      }
      notifyListeners();
    }
  }
}
