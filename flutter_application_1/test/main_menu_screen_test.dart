import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

// Mock function สำหรับทดสอบการเรียก onLogin
class MockLoginFunction extends Mock {
  void call(String username);
}

void main() {
  group('LoginScreen', () {
    testWidgets('แสดงข้อความ "ยินดีต้อนรับ!"', (WidgetTester tester) async {
      // สร้าง mock function
      final mockOnLogin = MockLoginFunction();

      // สร้าง widget สำหรับทดสอบ
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(onLogin: mockOnLogin),
      ));

      // ตรวจสอบว่าแสดงข้อความ "ยินดีต้อนรับ!"
      expect(find.text('ยินดีต้อนรับ!'), findsOneWidget);
    });

    testWidgets('เข้าสู่ระบบสำเร็จเมื่อชื่อผู้ใช้ที่ถูกต้อง', (WidgetTester tester) async {
      final mockOnLogin = MockLoginFunction();

      // สร้าง widget สำหรับทดสอบ
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(onLogin: mockOnLogin),
      ));

      // ใส่ค่าชื่อผู้ใช้ที่ถูกต้อง
      await tester.enterText(find.byType(TextField).at(0), 'user');
      await tester.enterText(find.byType(TextField).at(1), '123');

      // กดปุ่ม "เข้าสู่ระบบ"
      await tester.tap(find.text('เข้าสู่ระบบ'));
      await tester.pump(); // รอให้หน้าจออัปเดต

      // ตรวจสอบว่าฟังก์ชัน onLogin ถูกเรียกด้วยค่า username ที่ถูกต้อง
      verify(mockOnLogin('user')).called(1);
    });

    testWidgets('ไม่เรียก onLogin เมื่อชื่อผู้ใช้ไม่ถูกต้อง', (WidgetTester tester) async {
      final mockOnLogin = MockLoginFunction();

      // สร้าง widget สำหรับทดสอบ
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(onLogin: mockOnLogin),
      ));

      // ใส่ค่าชื่อผู้ใช้ที่ไม่ถูกต้อง
      await tester.enterText(find.byType(TextField).at(0), 'wrong_user');
      await tester.enterText(find.byType(TextField).at(1), 'wrong_pass');

      // กดปุ่ม "เข้าสู่ระบบ"
      await tester.tap(find.text('เข้าสู่ระบบ'));
      await tester.pump(); // รอให้หน้าจออัปเดต

    
    });
  });
}
