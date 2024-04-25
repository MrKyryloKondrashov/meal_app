import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false
};

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier() : super(kInitialFilters);

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  void setFilters(Map<Filter, bool> choosenFilters) {
    state = choosenFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((element) {
    if (activeFilters[Filter.glutenFree]! && !element.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !element.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !element.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !element.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
