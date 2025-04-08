import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'color_pallets/favorites_page.dart';
import 'color_pallets/history_page.dart';
import 'photo_analysis/camera_page.dart';
import 'text_analysis/recommendation_page.dart';
import 'extra_video_text/video_page.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('My Profile')));
}



void main() {
  runApp(BeautyBuddyApp());
}

class BeautyBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty Buddy',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardPage(),
        '/profile': (context) => MyProfilePage(),
        '/analysis': (context) => RecommendationPage(), // connects to camera/emotion
        '/history': (context) => HistoryPage(),
        '/favorites': (context) => FavoritesPage(),
        '/camera': (context) => CameraSystem(),
        // '/video': (context) =>  VideoPage(),
      },
    );
  }
}