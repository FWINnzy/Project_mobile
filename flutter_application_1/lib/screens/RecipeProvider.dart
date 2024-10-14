import 'package:flutter/material.dart';
import 'add_item_screen.dart';

// โมเดลสำหรับสูตรอาหาร
class Recipe {
  final String name;
  final String serving;
  final String time;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.name,
    required this.serving,
    required this.time,
    required this.ingredients,
    required this.steps,
  });
}

// Provider สำหรับเก็บข้อมูลของสูตรอาหาร
class RecipeProvider with ChangeNotifier {
  final List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners(); // แจ้ง UI ให้รู้ว่ามีการเปลี่ยนแปลงข้อมูล
  }
}
