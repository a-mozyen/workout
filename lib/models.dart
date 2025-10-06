class MuscleGroup {
  final String id;
  final String name;
  final String imagepath;

  const MuscleGroup({
    required this.id,
    required this.name,
    required this.imagepath,
  });
}

class Muscle {
  final String id;
  final String name;
  final String imagepath;
  final String muscleGroupId;

  const Muscle({
    required this.id,
    required this.name,
    required this.imagepath,
    required this.muscleGroupId,
  });
}

class Exercise {
  final String id;
  final String name;
  final String imagepath;
  final String muscleId;

  const Exercise({
    required this.id,
    required this.name,
    required this.imagepath,
    required this.muscleId,
  });
}

class PersonalInfo {
  final double heightCm;
  final double weightKg;
  final String gender; // 'male' | 'female'
  final int age;

  const PersonalInfo({
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.age,
  });

  double get bmi {
    final h = heightCm / 100.0;
    if (h <= 0) return 0;
    return weightKg / (h * h);
  }

  Map<String, Object> toJson() => {
    'heightCm': heightCm,
    'weightKg': weightKg,
    'gender': gender,
    'age': age,
  };

  factory PersonalInfo.fromJson(Map<String, Object?> json) {
    return PersonalInfo(
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      gender: (json['gender'] as String?) ?? 'male',
      age: (json['age'] as num?)?.toInt() ?? 0,
    );
  }
}

class FoodItem {
  final String foodType;
  final String quantity;

  const FoodItem({required this.foodType, required this.quantity});
}

class Meal {
  final String name; // Breakfast, Lunch, etc.
  final String day; // Monday, Tuesday, etc.
  final List<FoodItem> items;

  const Meal({required this.name, required this.day, this.items = const []});
}
