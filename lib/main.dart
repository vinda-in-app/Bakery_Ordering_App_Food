import 'package:flutter/material.dart';

// Mengimpor file-file dari folder Theme
import 'Theme/app_theme.dart';

// Mengimpor file-file dari folder Models dan DB
import 'Models/user_model.dart';
import 'DB/user_database.dart';

// Mengimpor semua halaman dari folder Pages
import 'Pages/start_page.dart';
import 'Pages/main_wrapper.dart';
import 'Pages/sign_in_page.dart';
import 'Pages/log_in_page.dart';

// ✅ Inisialisasi session global (harus di bawah semua import)
final sessionData = SessionData();

void main() {
  // 2. Menjalankan aplikasi utama Flutter
  runApp(const BakeryApp());
}

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Cozy Oven Bakery',

      // Menggunakan tema kustom yang dibuat di app_theme.dart
      theme: buildAppTheme(context),

      debugShowCheckedModeBanner: false,

      // Menentukan halaman awal aplikasi
      initialRoute: '/',

      // Mendefinisikan rute untuk navigasi antar halaman
      routes: {
        '/': (context) => const StartPage(),
        '/signin': (context) => const SignInPage(),
        '/login': (context) => const LogInPage(),

        // Rute untuk halaman utama (setelah Log In), yang berisi Bottom Nav Bar
        '/main': (context) => const MainWrapper(),
      },
    );
  }
}
