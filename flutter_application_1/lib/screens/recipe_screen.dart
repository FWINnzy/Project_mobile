import 'package:flutter/material.dart';
import 'dart:convert'; // สำหรับแปลง JSON
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class RecipeScreen extends StatefulWidget {
  final String mealId;
  final String mealName;

  RecipeScreen({required this.mealId, required this.mealName});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  Map<String, dynamic>? mealDetails;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    final url =
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          mealDetails = json.decode(response.body)['meals'][0];
        });

        // ตรวจสอบ URL ของวิดีโอ
        final videoUrl = mealDetails!['strYoutube'];
        if (videoUrl != null && videoUrl.isNotEmpty) {
          final videoId = YoutubePlayer.convertUrlToId(videoUrl);
          if (videoId != null) {
            _controller = YoutubePlayerController(
              initialVideoId: videoId,
              flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );
          } else {
            // แสดงข้อความถ้าวิดีโอ ID ไม่ถูกต้อง
            print("Video ID is null");
          }
        }
      } else {
        // จัดการกรณีไม่สามารถโหลดข้อมูลได้
        setState(() {
          mealDetails = null;
        });
      }
    } catch (error) {
      // จัดการข้อผิดพลาดที่เกิดขึ้น
      print('Error fetching meal details: $error');
      setState(() {
        mealDetails = null;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // ตรวจสอบว่า _controller ไม่เป็น null ก่อนปิด
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealName),
      ),
      body: mealDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity, // ทำให้ความกว้างเต็มขอบ
                        height: 200, // ตั้งความสูงตามที่ต้องการ
                        child: Image.network(
                          mealDetails!['strMealThumb'],
                          fit: BoxFit.cover, // ปรับขนาดให้เต็มพื้นที่
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ส่วนประกอบ:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // แสดงส่วนประกอบ
                    ...List.generate(20, (index) {
                      final ingredient =
                          mealDetails!['strIngredient${index + 1}'];
                      final measure = mealDetails!['strMeasure${index + 1}'];
                      if (ingredient != null && ingredient.isNotEmpty) {
                        return Text('- $ingredient: $measure');
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                    SizedBox(height: 16),
                    Text(
                      'วิธีทำ:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(mealDetails!['strInstructions']),
                    SizedBox(height: 16),
                    Text(
                      'วิดีโอสอนทำ:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        final url = mealDetails!['strYoutube'];
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text('ดูวิดีโอวิธีทำที่นี่'),
                    ),
                    // แสดงคลิปวิดีโอ
                    if (_controller != null)
                      YoutubePlayer(
                        controller: _controller!,
                        showVideoProgressIndicator: true,
                      )
                    else
                      Text("ไม่พบวิดีโอสอนทำ"),
                  ],
                ),
              ),
            ),
    );
  }
}
