import 'package:flutter/material.dart';
import 'RecipeProvider.dart'; // ตรวจสอบให้แน่ใจว่าได้ import Recipe Model

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'ส่วนผสม',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...recipe.ingredients.map((ingredient) => ListTile(
                  title: Text(ingredient),
                )),
            SizedBox(height: 20),
            Text(
              'ขั้นตอนการทำ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...recipe.steps.asMap().entries.map((entry) {
              int stepNumber = entry.key + 1;
              String stepDescription = entry.value;
              return ListTile(
                leading: CircleAvatar(child: Text('$stepNumber')),
                title: Text(stepDescription),
              );
            }),
          ],
        ),
      ),
    );
  }
}
