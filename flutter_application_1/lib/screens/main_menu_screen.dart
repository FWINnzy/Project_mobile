import 'package:flutter/material.dart';
import 'dart:convert'; // สำหรับแปลง JSON
import 'package:http/http.dart' as http;
import 'search_screen.dart';
import 'recipe_screen.dart'; // หน้าสำหรับแสดงสูตรอาหาร
import 'RecipeProvider.dart';


class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
  
  
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<dynamic> randomMeals = [];
  List<dynamic> otherMeals = [];
  List<dynamic> seafood = []; // ตัวแปรสำหรับเก็บข้อมูลเมนู Seafood

  @override
  void initState() {
    super.initState();
    fetchRandomMeals();
    fetchOtherMeals();
    fetchSeafood(); // เรียกใช้งานฟังก์ชันนี้ด้วย
  }

  // ฟังก์ชันสำหรับดึงข้อมูลเมนูสุ่มจาก API
  Future<void> fetchRandomMeals() async {
    final url = 'https://www.themealdb.com/api/json/v1/1/random.php';
    List<dynamic> meals = [];

    // ดึงข้อมูล 6 รายการสุ่มจาก API
    for (int i = 0; i < 6; i++) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        meals.add(data['meals'][0]); // เพิ่มเมนูในรายการ
      }
    }

    setState(() {
      randomMeals = meals;
    });
  }

  // ฟังก์ชันสำหรับดึงข้อมูลเมนูที่เริ่มต้นด้วย "p"
  Future<void> fetchOtherMeals() async {
    final url =
        'https://www.themealdb.com/api/json/v1/1/search.php?f=p'; // URL สำหรับดึงข้อมูลเมนูที่เริ่มต้นด้วย "p"
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        otherMeals = data['meals']; // จัดเก็บข้อมูลที่ดึงมา
      });
    }
  }

  // ฟังก์ชันสำหรับดึงข้อมูลเมนู Seafood
  Future<void> fetchSeafood() async {
    final url =
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'; // URL สำหรับดึงข้อมูลเมนู Seafood
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        seafood = data['meals']; // จัดเก็บข้อมูลที่ดึงมา
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 174, 61, 61),
        title: Row(
          children: [
            Icon(Icons.person, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onSubmitted: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(searchTerm: value),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'ค้นหา',
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'เมนูแนะนำ'),
            randomMeals.isEmpty
                ? Center(
                    child: CircularProgressIndicator()) // แสดง loading ระหว่างดึงข้อมูล
                : Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: randomMeals.length,
                      itemBuilder: (context, index) {
                        final meal = randomMeals[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeScreen(
                                  mealId: meal['idMeal'],
                                  mealName: meal['strMeal'],
                                ),
                              ),
                            );
                          },
                          child: MealCard(
                            mealName: meal['strMeal'],
                            imageUrl: meal['strMealThumb'],
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 16), // เว้นระยะห่าง
            SectionTitle(title: 'เมนู Seafood'),
            seafood.isEmpty
                ? Center(
                    child: CircularProgressIndicator()) // แสดง loading ระหว่างดึงข้อมูล
                : Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: seafood.length,
                      itemBuilder: (context, index) {
                        final meal = seafood[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeScreen(
                                  mealId: meal['idMeal'],
                                  mealName: meal['strMeal'],
                                ),
                              ),
                            );
                          },
                          child: MealCard(
                            mealName: meal['strMeal'],
                            imageUrl: meal['strMealThumb'],
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 16), // เว้นระยะห่าง
            SectionTitle(title: 'เมนูอื่น ๆ'),
            otherMeals.isEmpty
                ? Center(
                    child: CircularProgressIndicator()) // แสดง loading ระหว่างดึงข้อมูล
                : Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: otherMeals.length,
                      itemBuilder: (context, index) {
                        final meal = otherMeals[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeScreen(
                                  mealId: meal['idMeal'],
                                  mealName: meal['strMeal'],
                                ),
                              ),
                            );
                          },
                          child: MealCard(
                            mealName: meal['strMeal'],
                            imageUrl: meal['strMealThumb'],
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
}

class MealCard extends StatelessWidget {
  final String mealName;
  final String imageUrl;

  MealCard({required this.mealName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // เปลี่ยนตำแหน่งของเงา
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 120,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                mealName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
