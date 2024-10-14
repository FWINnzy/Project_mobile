import 'package:flutter/material.dart';
import 'profile_screen.dart'; 

class LoginScreen extends StatelessWidget {
  final Function(String) onLogin;

  LoginScreen({required this.onLogin});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 174, 61, 61),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ยินดีต้อนรับ!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'ชื่อผู้ใช้',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ตรวจสอบชื่อผู้ใช้และรหัสผ่าน
                String username = _usernameController.text;
                String password = _passwordController.text;

                // สมมุติว่า username คือ "user" และ password คือ "123"
                if (username == "user" && password == "123") {
                  // เรียกใช้ onLogin เมื่อเข้าสู่ระบบสำเร็จ
                  onLogin(username);
                  Navigator.pushReplacement; // กลับไปที่หน้า HomeScreen โดยไม่ต้องเปลี่ยนหน้า
                } else {
                  // แสดงข้อความเตือนถ้าชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง')),
                  );
                }
              },
              child: Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 174, 61, 61),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
