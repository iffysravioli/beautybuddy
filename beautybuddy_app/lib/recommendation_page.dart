import 'package:flutter/material.dart';

class RecommendationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mood Input Field
              Text(
                "Tell me your mood",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Type your mood here...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Happiness Ranking
              Text(
                "Rate your happiness",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.sentiment_very_dissatisfied, color: Colors.red),
                  Icon(Icons.sentiment_dissatisfied, color: Colors.orange),
                  Icon(Icons.sentiment_neutral, color: Colors.yellow),
                  Icon(Icons.sentiment_satisfied, color: Colors.lightGreen),
                  Icon(Icons.sentiment_very_satisfied, color: Colors.green),
                ],
              ),
              SizedBox(height: 20),

              // Weather Ranking
              Text(
                "How does the weather feel?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                hint: Text("Select weather"),
                items: ["Sunny", "Rainy", "Cloudy", "Snowy", "Windy"]
                    .map((weather) => DropdownMenuItem(
                  child: Text(weather),
                  value: weather,
                ))
                    .toList(),
                onChanged: (value) {
                  print("Selected weather: $value");
                },
              ),
              SizedBox(height: 20),

              // Occasion Input
              Text(
                "What's the occasion?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter occasion (e.g., wedding, work, casual)...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}