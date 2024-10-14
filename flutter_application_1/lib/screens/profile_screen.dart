import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeProvider.dart'; // ตรวจสอบให้แน่ใจว่าได้ import Recipe Model
 // ตรวจสอบให้แน่ใจว่าได้ import RecipeProvider
import 'RecipeDetailScreen.dart'; // Import RecipeDetailScreen

class ProfileScreen extends StatefulWidget {
  final String username;
  final bool isLoggedIn;

  ProfileScreen({required this.username, required this.isLoggedIn});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _username;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _isLoggedIn = widget.isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์ของฉัน', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 174, 61, 61),
      ),
      body: _isLoggedIn ? _buildLoggedInView() : _buildLoggedOutView(),
    );
  }

  Widget _buildLoggedInView() {
    final recipes = Provider.of<RecipeProvider>(context).recipes; // ดึงข้อมูลจาก RecipeProvider

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(_username, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'ที่บันทึกไว้'),
                    Tab(text: 'สูตรของฉัน'),
                  ],
                ),
                Container(
                  height: 300,
                  child: TabBarView(
                    children: [
                      Center(child: Text('รายการที่บันทึกไว้')),
                      recipes.isEmpty
                          ? Center(child: Text('ยังไม่มีสูตรอาหารที่คุณโพสต์'))
                          : ListView.builder(
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = recipes[index];
                                return ListTile(
                                  title: Text(recipe.name),
                                  subtitle: Text('เสิร์ฟ ${recipe.serving} ที่ | ใช้เวลา ${recipe.time}'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecipeDetailScreen(recipe: recipe),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedOutView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'กรุณาเข้าสู่ระบบเพื่อดูข้อมูลโปรไฟล์',
            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 174, 61, 61)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 174, 61, 61),
            ),
            onPressed: () {
              // นำผู้ใช้ไปยังหน้าล็อกอิน
            },
            child: Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
