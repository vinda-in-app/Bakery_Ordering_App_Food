import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_theme.dart';
import 'log_in_page.dart'; // Diimpor tapi tidak digunakan karena menggunakan Named Routes
import 'sign_in_page.dart'; // Diimpor tapi tidak digunakan karena menggunakan Named Routes

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menghapus NetworkImage. Menggantinya dengan warna solid dan overlay yang konsisten.
    return Scaffold(
      body: Stack(
        children: [
          // Background Color/Placeholder (Menggantikan gambar buram)
          Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1), // Base color sangat terang
            ),
          ),

          // Gradient Overlay (Tetap dipertahankan untuk efek transisi ke bawah)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  baseColor.withOpacity(0.5),
                  baseColor.withOpacity(0.8),
                  baseColor.withOpacity(0.95),
                  baseColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),

          // Content Utama (Column)
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 3),
                // Judul Utama
                Text(
                  'WELCOME TO',
                  style: GoogleFonts.fredoka(fontSize: 40, fontWeight: FontWeight.w600, color: primaryColor),
                ),
                Text(
                  'THE COZY\nOVEN BAKERY',
                  style: GoogleFonts.fredoka(fontSize: 50, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                const SizedBox(height: 10),
                Text(
                  '"Fresh from the Oven\nGoodness"',
                  style: GoogleFonts.didactGothic(fontSize: 28, color: primaryColor),
                ),
                const Spacer(flex: 1),

                // Instruksi
                Center(
                  child: Text(
                    'Please select one of the buttons to begin!',
                    style: GoogleFonts.didactGothic(fontSize: 16, color: primaryColor.withOpacity(0.8), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // Tombol SIGN IN / LOG IN
                Row(
                  children: [
                    // Tombol SIGN IN (Menggunakan rute '/signin')
                    Expanded(child: _buildAuthButton(context, 'SIGN IN', '/signin')),
                    const SizedBox(width: 20),
                    // Tombol LOG IN (Menggunakan rute '/login')
                    Expanded(child: _buildAuthButton(context, 'LOG IN', '/login')),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton(BuildContext context, String text, String route) {
    return GestureDetector(
      onTap: () {
        // Navigasi berdasarkan rute yang dikirimkan ('/signin' atau '/login')
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          // Warna tombol
          color: text == 'SIGN IN' ? secondaryColor : primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          // Border tombol
          border: Border.all(color: text == 'SIGN IN' ? primaryColor : secondaryColor, width: 3),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: text == 'SIGN IN' ? primaryColor : baseColor,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}