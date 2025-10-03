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
  final String sex; // 'male' | 'female'
  final int age;

  const PersonalInfo({
    required this.heightCm,
    required this.weightKg,
    required this.sex,
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
    'sex': sex,
    'age': age,
  };

  factory PersonalInfo.fromJson(Map<String, Object?> json) {
    return PersonalInfo(
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      sex: (json['sex'] as String?) ?? 'male',
      age: (json['age'] as num?)?.toInt() ?? 0,
    );
  }
}

class DietEntry {
  final DateTime date;
  final String mealName; // Breakfast, Lunch, etc.
  final String details; // Free text or structured summary

  const DietEntry({
    required this.date,
    required this.mealName,
    required this.details,
  });
}
