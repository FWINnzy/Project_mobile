import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_provider.dart'; // นำเข้า MealProvider
import 'meal.dart';
import 'recipe_screen.dart'; // นำเข้าหน้า RecipeScreen

class MenuGrid extends StatelessWidget {
  final bool isPopular;

  MenuGrid({required this.isPopular});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return FutureBuilder(
      future: isPopular ? mealProvider.fetchPopularMeals() : mealProvider.fetchLatestMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (mealProvider.meals.isEmpty) {
          return Center(child: Text('No meals found.'));
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // จำนวนคอลัมน์ใน Grid
            childAspectRatio: 0.75, // อัตราส่วนความกว้างต่อความสูงของแต่ละช่อง
          ),
          itemCount: mealProvider.meals.length,
          itemBuilder: (context, index) {
            final meal = mealProvider.meals[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeScreen(ingredient: meal.name),
                  ),
                );
              },
              child: Card(
                child: Column(
                  children: [
                    Image.network(
                      meal.imageUrl,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        meal.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
