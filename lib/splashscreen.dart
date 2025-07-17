import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kawaii_app/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F3), // 🎀 Kawaii pastel pink
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ perfect vertical center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Kawaii App',
                  textStyle: GoogleFonts.dynaPuff(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  colors: [
                    Color(0xFFFFA6C9), // pink
                    Color(0xFFA0E7E5), // mint
                    Color(0xFFFFF1B6), // yellow
                    Color(0xFFCDB4DB), // lavender
                  ],
                  speed: const Duration(milliseconds: 300),
                ),
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
          ],
        ),
      ),
    );
  }
}
