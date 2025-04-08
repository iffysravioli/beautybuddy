import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import 'history_page.dart';
import 'test_page.dart';

// Add placeholder pages
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
        '/analysis': (context) => HomePage(), // connects to camera/emotion
        '/history': (context) => HistoryPage(),
        '/favorites': (context) => FavoritesPage(),
        '/test': (context) => TestPage(),
      },
    );
  }
}