import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DEKLARASI KONSTANTA WARNA GLOBAL ---
// Dideklarasikan di luar class agar bisa diakses langsung (import '...')
const Color baseColor = Color(0xFFE3EFDD); // Krem (Latar Belakang)
const Color primaryColor = Color(0xFF6B8E5F); // Hijau Zaitun (Utama/Teks)
const Color secondaryColor = Color(0xFFDFB563); // Emas/Kuning (Aksen Sekunder)
const Color accentColor = Color(0xFFD34F4F); // Merah Tua (Aksen/Peringatan)

// Font Fredoka untuk Judul
final TextStyle fredokaTitleStyle = GoogleFonts.fredoka(fontWeight: FontWeight.bold);

// Font Didact Gothic untuk Teks Bodi
final TextStyle didactGothicBodyStyle = GoogleFonts.didactGothic(fontWeight: FontWeight.normal);


ThemeData buildAppTheme(BuildContext context) {
  return ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: baseColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: baseColor,
      error: accentColor,
    ),
    // Definisi Font Default
    textTheme: TextTheme(
      // Headline (untuk judul-judul besar)
      headlineLarge: fredokaTitleStyle.copyWith(fontSize: 32, color: primaryColor),
      headlineMedium: fredokaTitleStyle.copyWith(fontSize: 24, color: primaryColor),
      headlineSmall: fredokaTitleStyle.copyWith(fontSize: 20, color: primaryColor),

      // Body (untuk teks normal)
      bodyLarge: didactGothicBodyStyle.copyWith(fontSize: 18, color: primaryColor),
      bodyMedium: didactGothicBodyStyle.copyWith(fontSize: 16, color: primaryColor),
      bodySmall: didactGothicBodyStyle.copyWith(fontSize: 14, color: primaryColor),

      // Label (untuk teks input/navigasi)
      labelLarge: didactGothicBodyStyle.copyWith(fontSize: 16, color: primaryColor),
    ),
    // Pengaturan AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: baseColor,
      elevation: 0,
      foregroundColor: primaryColor,
      titleTextStyle: fredokaTitleStyle.copyWith(fontSize: 24, color: primaryColor),
    ),
  );
}
