import 'package:flutter/material.dart';
import 'screens/main_menu_screen.dart';
import 'screens/search_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/profile_screen.dart';  
import 'screens/add_item_screen.dart'; 
import 'package:provider/provider.dart';
import 'screens/data_provider.dart';
import 'screens/RecipeProvider.dart'; // นำเข้า MealProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MealProvider()),
        ChangeNotifierProvider(create: (context) => RecipeProvider()), // เพิ่ม RecipeProvider
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoggedIn = false;
  String _username = '';

  final List<Widget> _pages = [
    MainMenuScreen(),
    SearchScreen(), 
    Center(child: Text('หน้าสำหรับเพิ่มข้อมูล')),
    NotificationScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // สำหรับการจัดการปุ่ม Add
      if (isLoggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddRecipeScreen()),
        );
      } else {
        _handleLogin(context);
      }
    } else {
      setState(() {
        _selectedIndex = index; // อัปเดตหน้าที่แสดง
      });
    }
  }

  void _handleLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onLogin: (username) {
            setState(() {
              isLoggedIn = true;
              _username = username; // อัปเดตชื่อผู้ใช้
            });
            Navigator.pop(context); // กลับไปที่หน้าเดิม
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 4 
          ? ProfileScreen(username: _username, isLoggedIn: isLoggedIn) 
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
