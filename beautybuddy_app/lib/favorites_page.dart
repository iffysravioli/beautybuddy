import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteColors = [
    {"name": "", "color": Color(0xFF87CEEB), "addedOn": DateTime.now(), "frequency": Random().nextInt(20) + 1},
    {"name": "", "color": Color(0xFFFFB6C1), "addedOn": DateTime.now(), "frequency": Random().nextInt(20) + 1},
    {"name": "", "color": Color(0xFF228B22), "addedOn": DateTime.now(), "frequency": Random().nextInt(20) + 1},
  ];

  Color selectedColor = Colors.blue;
  String customName = "";
  Map<String, dynamic>? selectedColorDetails;

  void _showColorDetails(BuildContext context, Map<String, dynamic> colorInfo) {
    setState(() {
      selectedColorDetails = colorInfo;
    });
  }

  void _closeColorDetails() {
    setState(() {
      selectedColorDetails = null;
    });
  }

  void _addFavoriteColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick a Color"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Custom Name"),
                onChanged: (value) {
                  customName = value;
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  favoriteColors.add({
                    "name": customName,
                    "color": selectedColor,
                    "addedOn": DateTime.now(),
                    "frequency": 1,
                  });
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Colors'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white),
            onPressed: _addFavoriteColor,
          )
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favoriteColors.length,
            itemBuilder: (context, index) {
              final favorite = favoriteColors[index];
              return GestureDetector(
                onLongPress: () => _showColorDetails(context, favorite),
                child: Container(
                  decoration: BoxDecoration(
                    color: favorite['color'],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              );
            },
          ),
          if (selectedColorDetails != null)
            Positioned(
              left: 50,
              right: 50,
              top: MediaQuery.of(context).size.height * 0.3,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedColorDetails!["name"].isEmpty
                            ? "Unnamed Color"
                            : selectedColorDetails!["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: selectedColorDetails!["color"],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Hex: #${selectedColorDetails!["color"].value.toRadixString(16).toUpperCase()}",
                          style: TextStyle(fontSize: 16)),
                      Text("Added On: ${selectedColorDetails!["addedOn"].toLocal().toString().split(' ')[0]}",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      Text("Frequency: ${selectedColorDetails!["frequency"]}",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: _closeColorDetails,
                        child: Text("Close"),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
