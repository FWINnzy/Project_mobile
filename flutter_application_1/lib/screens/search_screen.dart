import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // นำเข้า provider
import 'recipe_screen.dart'; // Import หน้าสูตรอาหาร
import 'data_provider.dart'; // Import MealProvider


class SearchScreen extends StatefulWidget {
  final String? searchTerm; // รับค่าคำค้นหาเป็น nullable

  SearchScreen({this.searchTerm}); // Constructor

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  // รายการวัตถุดิบที่ค้นพบ
  List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    if (widget.searchTerm != null) {
      _controller.text = widget.searchTerm!; // ตั้งค่าคำค้นหาถ้ามี
      _searchIngredient(); // ค้นหาทันทีเมื่อมีคำค้นหา
    }
  }

  void _searchIngredient() async {
    final searchTerm = _controller.text;
    if (searchTerm.isEmpty) return;

    setState(() {
      _ingredients = []; // ล้างรายการก่อนค้นหา
    });

    try {
      // ใช้ Provider เพื่อเข้าถึง MealProvider
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      await mealProvider.searchMeals(searchTerm); // ค้นหามื้ออาหาร
      setState(() {
        _ingredients = mealProvider.meals
            .map((meal) => meal.name)
            .toList(); // อัปเดตรายการวัตถุดิบ
      });
    } catch (e) {
      print('Error fetching ingredients: $e');
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
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) =>
                      _searchIngredient(), // ค้นหาทันทีเมื่อกด Enter
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
      body: Container(
        color: Color.fromARGB(255, 174, 61, 61),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<MealProvider>(
            builder: (ctx, mealProvider, _) {
              // เช็คสถานะการโหลด
              if (mealProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              // เช็คว่ามีมื้ออาหารหรือไม่
              if (mealProvider.meals.isEmpty) {
                return Center(
                    child: Text('ไม่พบวัตถุดิบ',
                        style: TextStyle(color: Colors.white)));
              }

              // ถ้ามีมื้ออาหาร แสดง GridView
              return GridView.builder(
                itemCount: mealProvider.meals.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final meal = mealProvider.meals[index]; // ดึงมื้ออาหาร
                  return GestureDetector(
                    onTap: () {
                      // นำทางไปยังหน้าสูตรอาหารเมื่อกดเลือกมื้ออาหาร
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeScreen(
                            mealId: meal.idMeal,  // ส่ง idMeal ไปยัง RecipeScreen
                            mealName: meal.name,  // ส่งชื่อเมนูไปด้วย
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.grey[300],
                      child: Column(
                        children: [
                          // แสดงรูปภาพของมื้ออาหาร
                          Image.network(
                            meal.imageUrl,
                            height: 200, // กำหนดความสูงของรูปภาพ
                            width: double.infinity, // ให้กว้างเต็มที่
                            fit: BoxFit.cover, // ปรับให้เข้ากับกรอบ
                          ),
                          SizedBox(height: 8), // เว้นระยะห่างระหว่างรูปและชื่อ
                          Center(
                            child: Text(
                              meal.name,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center, // จัดตำแหน่งข้อความกลาง
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
