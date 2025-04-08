import 'package:flutter/material.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6B4D3C), // Top: rich brown
              Color(0xFFE0B199), // Bottom: light peachy beige
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/beauty_background.png', // update path if needed
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              // Title
              Text(
                'Welcome to\nBeauty Buddy!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Buttons
              // _buildGradientButton(context, 'My Profile', '/profile'),
              _buildGradientButton(context, 'Camera', '/camera'),
              _buildGradientButton(context, 'Text Analysis', '/analysis'),
              _buildGradientButton(context, 'History', '/history'),
              _buildGradientButton(context, 'Favorites', '/favorites'),
              // _buildGradientButton(context, 'Video', '/video'),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5C3A24), Color(0xFFD3B9AA)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, route),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Serif',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}