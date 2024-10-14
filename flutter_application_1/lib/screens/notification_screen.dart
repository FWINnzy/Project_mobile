import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือน'),
        backgroundColor: Color.fromARGB(255, 174, 61, 61), // สีพื้นหลังของ AppBar
      ),
      body: ListView.builder(
        itemCount: 10, // จำนวนรายการแจ้งเตือน
        itemBuilder: (context, index) {
          return NotificationItem(
            title: 'การแจ้งเตือนที่ ${index + 1}',
            message: 'รายละเอียดการแจ้งเตือนที่ ${index + 1}',
            time: '${index + 1} ชั่วโมงที่แล้ว',
          );
        },
      ),
    );
  }
}

// Widget สำหรับแสดงการแจ้งเตือนแต่ละรายการ
class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
