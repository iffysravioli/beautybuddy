import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'favorites_page.dart';
import 'history_page.dart';
import 'camera_page.dart';
import 'recommendation_page.dart';


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
      },
    );
  }
}