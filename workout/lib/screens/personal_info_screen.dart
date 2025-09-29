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
    return Scaffold(
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
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _sex,
                decoration: const InputDecoration(labelText: 'Sex'),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: (v) => setState(() => _sex = v ?? 'male'),
              ),
              const SizedBox(height: 20),
              if (bmi != null)
                Text(
                  'BMI: ${bmi.toStringAsFixed(1)} (${_bmiCategory(bmi)})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
                    await context.read<WorkoutProvider>().setPersonalInfo(info);
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
    );
  }
}

String _bmiCategory(double bmi) {
  if (bmi < 18.5) return 'Underweight';
  if (bmi < 25) return 'Normal';
  if (bmi < 30) return 'Overweight';
  return 'Obese';
}
