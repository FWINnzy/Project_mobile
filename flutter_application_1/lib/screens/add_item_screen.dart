import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeProvider.dart';


class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _ingredients = <String>[]; // List เก็บส่วนผสม
  final _steps = <String>[];       // List เก็บขั้นตอนการทำ
  final _recipeNameController = TextEditingController();
  final _servingController = TextEditingController();
  final _timeController = TextEditingController();


  // ฟังก์ชันสำหรับโพสต์ข้อมูล
  void _postRecipe() {
    if (_recipeNameController.text.isEmpty) {
      // ถ้าชื่อสูตรยังไม่ได้ใส่ ให้แสดงแจ้งเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกชื่อสูตรอาหาร')),
      );
      return;
    }

    final recipe = Recipe(
      name: _recipeNameController.text,
      serving: _servingController.text,
      time: _timeController.text,
      ingredients: _ingredients,
      steps: _steps,
    );

    // เพิ่มสูตรอาหารไปยัง RecipeProvider
    Provider.of<RecipeProvider>(context, listen: false).addRecipe(recipe);

    // แสดงข้อความสำเร็จ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('โพสต์สูตรอาหารสำเร็จ')),
    );

    // กลับไปยังหน้าก่อนหน้า (เช่น เมนูหลัก)
    Navigator.pop(context);
  }
  // สำหรับเพิ่มส่วนผสม
  void _addIngredient(String ingredient) {
    setState(() {
      _ingredients.add(ingredient);
    });
  }

  // สำหรับเพิ่มขั้นตอน
  void _addStep(String step) {
    setState(() {
      _steps.add(step);
    });
  }

  // แสดง dialog ให้เพิ่มข้อมูลส่วนผสม/ขั้นตอน
  Future<void> _showAddDialog(String title, Function(String) onAdd) async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
          actions: [
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('เพิ่ม'),
              onPressed: () {
                onAdd(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันสำหรับบันทึกข้อมูล
  void _saveRecipe() {
    // คุณสามารถเพิ่มฟังก์ชันการบันทึกข้อมูลที่นี่ (เช่น บันทึกลงในฐานข้อมูล)
    print('บันทึกข้อมูล: ${_recipeNameController.text}, เสิร์ฟ: ${_servingController.text}, เวลา: ${_timeController.text}');
    print('ส่วนผสม: $_ingredients');
    print('วิธีทำ: $_steps');
  }

  // ฟังก์ชันสำหรับโพสต์ข้อมูล
  // void _postRecipe() {
  //   // เพิ่มฟังก์ชันการโพสต์ข้อมูลที่นี่ (เช่น ส่งข้อมูลไปยังเซิร์ฟเวอร์)
  //   print('โพสต์สูตรอาหาร: ${_recipeNameController.text}');
  // }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _servingController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: Text('บันทึก', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: _postRecipe,
            child: Text('โพสต์', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'ใส่รูปอาหารที่ทำเสร็จ',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildTextField('ชื่อสูตร: ข้าวผัดสูตรเด็ดของฉัน', controller: _recipeNameController),
            _buildTextField('สำหรับ', controller: _servingController, value: '2 ที่'),
            _buildTextField('เวลาที่ใช้', controller: _timeController, value: '30 นาที'),
            Divider(),
            _buildSectionTitle('ส่วนผสม'),
            ..._ingredients.map((ingredient) => ListTile(title: Text(ingredient))).toList(),
            _buildAddButton('เพิ่มส่วนผสม', () {
              _showAddDialog('เพิ่มส่วนผสม', _addIngredient);
            }),
            Divider(),
            _buildSectionTitle('วิธีทำ'),
            ..._steps.map((step) => ListTile(title: Text(step))).toList(),
            _buildAddButton('เพิ่มขั้นตอน', () {
              _showAddDialog('เพิ่มขั้นตอน', _addStep);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {TextEditingController? controller, String value = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: value,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAddButton(String text, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.add),
      label: Text(text),
    );
  }
}
