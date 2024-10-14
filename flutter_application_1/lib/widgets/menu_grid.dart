import 'package:flutter/material.dart';

class MenuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // จำนวนคอลัมน์
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: 4, // จำนวนรายการ
        itemBuilder: (context, index) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Text(
                'รายการ ${index + 1}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
