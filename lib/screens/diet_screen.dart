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
  final List<Meal> _meals = [];

  @override
  Widget build(BuildContext context) {
    final info = context.watch<WorkoutProvider>().personalInfo;
    final recommendation = _recommendationFor(info);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Diet'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add meal',
        onPressed: _addMeal,
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
              child: _meals.isEmpty
                  ? const Center(child: Text('No meals scheduled.'))
                  : ListView.builder(
                      itemCount: _meals.length,
                      itemBuilder: (context, index) {
                        final meal = _meals[index];
                        return ExpansionTile(
                          title: Text('${meal.name} - ${meal.day}'),
                          children: [
                            // TODO: Integrate LM here to calculate total intake from meal.items.
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: meal.items.length,
                              itemBuilder: (context, itemIndex) {
                                final item = meal.items[itemIndex];
                                return ListTile(
                                  title: Text(item.foodType),
                                  subtitle: Text(item.quantity),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {
                                      setState(() {
                                        final oldMeal = _meals[index];
                                        final newItems = List<FoodItem>.from(
                                          oldMeal.items,
                                        )..removeAt(itemIndex);
                                        final newMeal = Meal(
                                          name: oldMeal.name,
                                          day: oldMeal.day,
                                          items: newItems,
                                        );
                                        _meals[index] = newMeal;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Add Food'),
                              onPressed: () => _addFoodItem(index),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _addMeal() async {
    final result = await showDialog<Meal>(
      context: context,
      builder: (context) => const _AddMealDialog(),
    );
    if (result != null) {
      setState(() => _meals.add(result));
    }
  }

  void _addFoodItem(int mealIndex) async {
    final result = await showDialog<FoodItem>(
      context: context,
      builder: (context) => const _AddFoodItemDialog(),
    );
    if (result != null) {
      setState(() {
        final oldMeal = _meals[mealIndex];
        final newItems = List<FoodItem>.from(oldMeal.items)..add(result);
        final newMeal = Meal(
          name: oldMeal.name,
          day: oldMeal.day,
          items: newItems,
        );
        _meals[mealIndex] = newMeal;
      });
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
    final bmr = info.gender == 'male'
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

class _AddMealDialog extends StatefulWidget {
  const _AddMealDialog();

  @override
  State<_AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<_AddMealDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mealCtrl = TextEditingController();
  String _day = 'Monday';

  @override
  void dispose() {
    _mealCtrl.dispose();
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
              decoration: const InputDecoration(
                labelText: 'Meal (e.g. breakfast)',
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(labelText: 'Day'),
              items: const [
                DropdownMenuItem(value: 'Monday', child: Text('Monday')),
                DropdownMenuItem(value: 'Tuesday', child: Text('Tuesday')),
                DropdownMenuItem(value: 'Wednesday', child: Text('Wednesday')),
                DropdownMenuItem(value: 'Thursday', child: Text('Thursday')),
                DropdownMenuItem(value: 'Friday', child: Text('Friday')),
                DropdownMenuItem(value: 'Saturday', child: Text('Saturday')),
                DropdownMenuItem(value: 'Sunday', child: Text('Sunday')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _day = v);
              },
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
              Navigator.of(context).pop(Meal(name: _mealCtrl.text, day: _day));
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _AddFoodItemDialog extends StatefulWidget {
  const _AddFoodItemDialog();

  @override
  State<_AddFoodItemDialog> createState() => _AddFoodItemDialogState();
}

class _AddFoodItemDialogState extends State<_AddFoodItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _foodTypeCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();

  @override
  void dispose() {
    _foodTypeCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add food item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _foodTypeCtrl,
              decoration: const InputDecoration(
                labelText: 'Food type (e.g. eggs)',
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _quantityCtrl,
              decoration: const InputDecoration(labelText: 'Quantity'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
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
                FoodItem(
                  foodType: _foodTypeCtrl.text,
                  quantity: _quantityCtrl.text,
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
