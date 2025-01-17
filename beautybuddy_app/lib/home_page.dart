import 'package:flutter/material.dart';
import 'recommendation_page.dart';
import 'favorites_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          RecommendationPage(), // Swipe left
          Center(
            child: Text(
              "Add Camera",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ), // Main page
          FavoritesPage(), // Swipe right
        ],
        onPageChanged: (index) {
          print("Page changed to index: $index");
        },
      ),
    );
  }
}