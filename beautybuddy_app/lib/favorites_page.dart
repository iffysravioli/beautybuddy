import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteColors = [
    {"name": "Sky Blue", "color": Colors.blue},
    {"name": "Soft Pink", "color": Colors.pink},
    {"name": "Forest Green", "color": Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: favoriteColors.length,
        itemBuilder: (context, index) {
          final favorite = favoriteColors[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: favorite['color'],
            ),
            title: Text(favorite['name']),
          );
        },
      ),
    );
  }
}