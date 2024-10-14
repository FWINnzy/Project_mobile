import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'meal.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  bool _isLoading = false;

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;

  Future<void> searchMeals(String mealName) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$mealName';

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['meals'] != null) {
          _meals = (jsonData['meals'] as List)
              .map((mealJson) => Meal.fromJson(mealJson))
              .toList();
        } else {
          _meals = []; // ไม่มีเมนูอาหาร
        }
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      print('Failed to load meals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLatestMeals() async {
    final url = 'https://www.themealdb.com/api/json/v1/1/random.php';

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['meals'] != null) {
          _meals = (jsonData['meals'] as List)
              .map((mealJson) => Meal.fromJson(mealJson))
              .toList();
        } else {
          _meals = []; // ไม่มีเมนูอาหาร
        }
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      print('Failed to load meals: $e');
    } finally {
      _isLoading = false; // ตั้งค่าไม่ให้โหลดอีก
      notifyListeners();
    }
  }
  Future<void> fetchPopularMeals() async {
    final url = 'https://www.themealdb.com/api/json/v1/1/random.php';

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['meals'] != null) {
          _meals = (jsonData['meals'] as List)
              .map((mealJson) => Meal.fromJson(mealJson))
              .toList();
        } else {
          _meals = []; // ไม่มีเมนูอาหาร
        }
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      print('Failed to load meals: $e');
    } finally {
      _isLoading = false; // ตั้งค่าไม่ให้โหลดอีก
      notifyListeners();
    }
  }

  Future<List<String>> searchIngredients(String term) async {
    return List.generate(6, (index) => 'วัตถุดิบ ${index + 1}');
  }
}
