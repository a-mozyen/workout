import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../workout_provider.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final List<DietEntry> _entries = [];

  @override
  Widget build(BuildContext context) {
    final info = context.watch<WorkoutProvider>().personalInfo;
    final recommendation = _recommendationFor(info);
    return Scaffold(
      appBar: AppBar(title: const Text('Diet')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add meal',
        onPressed: _addEntry,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended daily intake',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(recommendation),
            const Divider(height: 32),
            Expanded(
              child: _entries.isEmpty
                  ? const Center(child: Text('No meals scheduled.'))
                  : ListView.separated(
                      itemCount: _entries.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final e = _entries[index];
                        return ListTile(
                          title: Text('${e.mealName} - ${_fmtDate(e.date)}'),
                          subtitle: Text(e.details),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                setState(() => _entries.removeAt(index)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _addEntry() async {
    final result = await showDialog<DietEntry>(
      context: context,
      builder: (context) => const _DietEntryDialog(),
    );
    if (result != null) {
      setState(() => _entries.add(result));
    }
  }

  String _recommendationFor(PersonalInfo? info) {
    if (info == null ||
        info.heightCm <= 0 ||
        info.weightKg <= 0 ||
        info.age <= 0) {
      return 'Enter personal info to get tailored recommendations.';
    }
    // Simple Mifflin-St Jeor TDEE estimate with sedentary factor as placeholder.
    final bmr = info.sex == 'male'
        ? (10 * info.weightKg) + (6.25 * info.heightCm) - (5 * info.age) + 5
        : (10 * info.weightKg) + (6.25 * info.heightCm) - (5 * info.age) - 161;
    final tdee = bmr * 1.2; // sedentary
    final protein = info.weightKg * 1.6; // g/day
    final fat = info.weightKg * 0.9; // g/day
    final carbsKcal = tdee - (protein * 4) - (fat * 9);
    final carbs = (carbsKcal / 4).clamp(0, 1000);
    return 'Calories: ${tdee.round()} kcal  •  Protein: ${protein.round()} g  \nFat: ${fat.round()} g  •  Carbs: ${carbs.round()} g';
  }
}

class _DietEntryDialog extends StatefulWidget {
  const _DietEntryDialog();

  @override
  State<_DietEntryDialog> createState() => _DietEntryDialogState();
}

class _DietEntryDialogState extends State<_DietEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  final _mealCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();

  @override
  void dispose() {
    _mealCtrl.dispose();
    _detailsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add meal'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _mealCtrl,
              decoration: const InputDecoration(labelText: 'Meal name'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _detailsCtrl,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${_date.year}-${_date.month}-${_date.day}'),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      initialDate: _date,
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  child: const Text('Pick date'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(
                DietEntry(
                  date: _date,
                  mealName: _mealCtrl.text,
                  details: _detailsCtrl.text,
                ),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
