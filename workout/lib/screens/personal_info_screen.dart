import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../workout_provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _heightCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _ageCtrl;
  String _sex = 'male';

  @override
  void initState() {
    super.initState();
    final provider = context.read<WorkoutProvider>();
    final info = provider.personalInfo;
    _heightCtrl = TextEditingController(text: info?.heightCm.toString() ?? '');
    _weightCtrl = TextEditingController(text: info?.weightKg.toString() ?? '');
    _ageCtrl = TextEditingController(text: info?.age.toString() ?? '');
    _sex = info?.sex ?? 'male';
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final bmi = provider.personalInfo?.bmi;
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          // Non-floating label size
          labelStyle: const TextStyle(fontSize: 20),
          // Floating label size
          floatingLabelStyle: const TextStyle(fontSize: 20),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Personal Info')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _heightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  validator: (v) {
                    final d = double.tryParse(v ?? '');
                    if (d == null || d <= 0) return 'Enter valid height';
                    return null;
                  },
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _weightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  validator: (v) {
                    final d = double.tryParse(v ?? '');
                    if (d == null || d <= 0) return 'Enter valid weight';
                    return null;
                  },
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                  validator: (v) {
                    final d = int.tryParse(v ?? '');
                    if (d == null || d <= 0) return 'Enter valid age';
                    return null;
                  },
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _sex,
                  decoration: const InputDecoration(labelText: 'Sex'),
                  items: const [
                    DropdownMenuItem(
                      value: 'male',
                      child: Text('Male', style: TextStyle(fontSize: 20)),
                    ),
                    DropdownMenuItem(
                      value: 'female',
                      child: Text('Female', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                  onChanged: (v) => setState(() => _sex = v ?? 'male'),
                ),
                const SizedBox(height: 20),
                if (bmi != null) ...[
                  Text(
                    'BMI: ${bmi.toStringAsFixed(1)} (${_bmiCategory(bmi)}) • Ideal weight: ${_idealWeightKg(provider.personalInfo).toStringAsFixed(1)} kg',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final info = PersonalInfo(
                        heightCm: double.parse(_heightCtrl.text),
                        weightKg: double.parse(_weightCtrl.text),
                        sex: _sex,
                        age: int.parse(_ageCtrl.text),
                      );
                      await context.read<WorkoutProvider>().setPersonalInfo(
                        info,
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _bmiCategory(double bmi) {
  if (bmi < 18.5) return 'Underweight';
  if (bmi < 25) return 'Normal';
  if (bmi < 30) return 'Overweight';
  return 'Obese';
}

double _idealWeightKg(PersonalInfo? info) {
  if (info == null || info.heightCm <= 0) return 0;
  // Devine formula: base at 5ft (152.4cm), +2.3kg per inch over
  final bool isFemale = info.sex == 'female';
  final double baseKg = isFemale ? 45.5 : 50.0;
  final double heightInches = info.heightCm / 2.54;
  final double inchesOverFiveFeet = heightInches - 60.0;
  final double additional = inchesOverFiveFeet > 0
      ? inchesOverFiveFeet * 2.3
      : 0.0;
  final double ideal = baseKg + additional;
  return ideal > 0 ? ideal : baseKg;
}
