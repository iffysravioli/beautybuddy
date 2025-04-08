import 'package:flutter/material.dart';
import 'RecommendationAnalysisPage.dart'; // <-- Create this page to handle logic

class RecommendationPage extends StatefulWidget {
  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  String? selectedWeather;
  int? selectedHappinessIndex;
  final List<Map<String, String>> occasions = [
    {'emoji': '💍', 'label': 'Wedding'},
    {'emoji': '💼', 'label': 'Work'},
    {'emoji': '🏖️', 'label': 'Vacation'},
    {'emoji': '🎉', 'label': 'Party'},
    {'emoji': '🛋️', 'label': 'Casual'},
    {'emoji': '🏫', 'label': 'School'},
  ];

  String? selectedOccasion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E1F0D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/beauty_background.png',
                  height: 80,
                ),
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("Rate your happiness"),
              const SizedBox(height: 10),
              _buildHappinessRow(),
              const SizedBox(height: 20),
              _buildSectionTitle("How does the weather feel?"),
              _buildDropdown(),
              const SizedBox(height: 20),
              _buildSectionTitle("Pick an occasion"),
              const SizedBox(height: 10),
              _buildOccasionSwiper(),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedHappinessIndex != null &&
                        selectedWeather != null &&
                        selectedOccasion != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecommendationAnalysisPage(
                            weather: selectedWeather!,
                            happinessLevel: selectedHappinessIndex!,
                            occasion: selectedOccasion!, // Add this var
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF3E1F0D),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Get My Color Recommendation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedWeather,
      dropdownColor: Colors.brown[300],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      hint: const Text("Select weather", style: TextStyle(color: Colors.white)),
      style: const TextStyle(color: Colors.white),
      items: ["Sunny", "Rainy", "Cloudy", "Snowy", "Windy"]
          .map((weather) => DropdownMenuItem(
        child: Text(weather),
        value: weather,
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedWeather = value;
        });
      },
    );
  }

  Widget _buildHappinessRow() {
    final icons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedHappinessIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedHappinessIndex == index ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              icons[index],
              color: colors[index],
              size: 36,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOccasionSwiper() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: occasions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final emoji = occasions[index]['emoji']!;
          final label = occasions[index]['label']!;
          final isSelected = selectedOccasion == label;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedOccasion = label;
              });
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}