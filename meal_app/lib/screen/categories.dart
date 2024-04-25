import 'package:flutter/material.dart';
import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/models/category.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screen/meals.dart';
import 'package:meal_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
        lowerBound: 0,
        upperBound: 1);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCaegory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((el) => el.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            MealsScreen(title: category.title, meals: filteredMeals)));
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return AnimatedBuilder(
      animation: _animationController,
      //builder: ((ctx, child) => Padding(padding: EdgeInsets.only(top : 200- _animationController.value * 100), child: child,)),
      builder: ((ctx, child) => SlideTransition(
            position:
                Tween(begin: const Offset(0, 0.4), end: const Offset(0, 0),).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInBack)),
            child: child,
          )),
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onTap: () {
                _selectCaegory(context, category);
              },
            ),
        ],
      ),
    );
  }
}
