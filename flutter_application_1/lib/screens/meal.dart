class Meal {
  final String idMeal; // เพิ่ม idMeal
  final String name;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;
  final String youtubeUrl;

  Meal({
    required this.idMeal, // รับค่า idMeal
    required this.name,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
    required this.youtubeUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    // ดึงวัตถุดิบจาก json และกรองเฉพาะที่มีค่า
    List<String> ingredients = [];
    for (int i = 1; i <= 30; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
      }
    }

    return Meal(
      idMeal: json['idMeal'] ?? '', // ดึงค่า idMeal จาก JSON
      name: json['strMeal'] ?? 'Unknown', // กรณีไม่มีชื่อ
      imageUrl: json['strMealThumb'] ?? '', // ตรวจสอบว่ามีรูปภาพหรือไม่
      instructions: json['strInstructions'] ?? 'No instructions available.', // ตรวจสอบว่ามีคำอธิบายหรือไม่
      ingredients: ingredients, // เพิ่มวัตถุดิบที่กรองแล้ว
      youtubeUrl: json['strYoutube'] ?? '', // ตรวจสอบว่ามีลิงก์ YouTube หรือไม่
    );
  }
}
