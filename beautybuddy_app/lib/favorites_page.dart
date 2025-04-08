import 'dart:math';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Full color pool
  final List<Color> availableColors = [
    Color(0xFF0000FF),
    Color(0xFFB388EB),
    Color(0xFFADD8E6),
    Color(0xFF228B22),
    Color(0xFF3F3D56),
    Color(0xFF4B0082),
    Color(0xFF0F0F0F),
    Color(0xFF2E8B57),
    Color(0xFF4169E1),
    Color(0xFF6495ED),
    Color(0xFFCD853F),
    Color(0xFFF5DEB3),
    Color(0xFF8B4513),
    Color(0xFFFFC0CB),
    Color(0xFF87CEFA),
    Color(0xFFFF4500),
    Color(0xFFD2B48C),
    Color(0xFF3C3C3C),
  ];

  List<Color> selectedColors = [];

  void _toggleColor(Color color) {
    setState(() {
      if (selectedColors.contains(color)) {
        selectedColors.remove(color);
      } else {
        if (selectedColors.length < 8) {
          selectedColors.add(color);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You can only select up to 8 colors.")),
          );
        }
      }
    });
  }

  void _clearPalette() {
    setState(() {
      selectedColors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _clearPalette,
            icon: Icon(Icons.delete_outline, color: Colors.black),
            tooltip: 'Clear Palette',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Faint watermark background
          Opacity(
            opacity: 0.06,
            child: Center(
              child: Image.asset(
                'assets/images/beauty_background.png', // update with your asset
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Selected Palette Preview
                if (selectedColors.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.grey.withOpacity(0.2),
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedColors
                          .map((color) => Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(color: Colors.black12),
                        ),
                      ))
                          .toList(),
                    ),
                  ),

                // Color Selector Grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: availableColors.map((color) {
                      final isSelected = selectedColors.contains(color);
                      return GestureDetector(
                        onTap: () => _toggleColor(color),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.white,
                              width: isSelected ? 3 : 2,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              )
                            ]
                                : [],
                          ),
                          child: isSelected
                              ? Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Add Button
                ElevatedButton.icon(
                  onPressed: selectedColors.isEmpty
                      ? null
                      : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Palette saved! (not yet persisted)"),
                      ),
                    );
                  },
                  icon: Icon(Icons.palette),
                  label: Text("Add to My Palette"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}