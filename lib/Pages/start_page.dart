import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_theme.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Simulasi background dari mockup
          image: DecorationImage(
            image: NetworkImage('[https://i.ibb.co/LpLhM8L/Start-Page-bg.jpg](https://i.ibb.co/LpLhM8L/Start-Page-bg.jpg)'), // Contoh gambar bakery
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Utama
              Text(
                'WELCOME TO',
                style: GoogleFonts.fredoka(fontSize: 36, color: baseColor),
              ),
              Text(
                'THE COZY\nOVEN BAKERY',
                style: GoogleFonts.fredoka(fontSize: 48, color: primaryColor),
              ),
              const SizedBox(height: 10),
              Text(
                '"Fresh from the Oven\nGoodness"',
                style: GoogleFonts.didactGothic(fontSize: 28, color: baseColor),
              ),
              const SizedBox(height: 120),

              Text(
                'Please select one of the buttons to begin!',
                style: GoogleFonts.didactGothic(fontSize: 16, color: baseColor.withOpacity(0.9)),
              ),
              const SizedBox(height: 10),

              // Tombol SIGN IN / LOG IN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildAuthButton(context, 'SIGN IN', '/signin')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildAuthButton(context, 'LOG IN', '/login')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor.withOpacity(0.8),
        foregroundColor: baseColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: secondaryColor, width: 2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        elevation: 10,
      ),
      child: Text(
        text,
        style: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
