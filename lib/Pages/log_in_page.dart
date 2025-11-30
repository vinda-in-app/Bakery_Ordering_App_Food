// File: lib/Pages/log_in_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_theme.dart';
import '../Widgets/rounded_input.dart';
import '../DB/sqlite_helper.dart';      // ⬅️ PAKAI SQLITE
import '../Models/user_model.dart';
import 'main_wrapper.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // Controller input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Session (diambil dari UserModel setelah login)
  final SessionData _sessionData = SessionData();

  // SQLite helper
  final SQLiteHelper _sqliteHelper = SQLiteHelper();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // -------------------------------------------------
  //                 LOGIN FUNCTION (SQLite)
  // -------------------------------------------------
  Future<void> _handleLogin() async {
    final String username = _usernameController.text.trim().toLowerCase();
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong!"),
        ),
      );
      return;
    }

    try {
      // 🔍 Ambil user dari SQLite (case-insensitive, by username)
      final UserModel? user =
      await _sqliteHelper.getUserByUsername(username);

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Akun tidak ditemukan."),
            backgroundColor: accentColor,
          ),
        );
        return;
      }

      // 🔐 Cek password
      // NOTE:
      //  - Kalau di SIGN IN kamu simpan password "mentah", pakai perbandingan langsung:
      //      if (user.password != password) { ... }
      //  - Kalau nanti pakai hashing (security.dart), ganti bagian ini agar cocok
      if (user.password != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password salah."),
            backgroundColor: accentColor,
          ),
        );
        return;
      }

      // ✔ Login berhasil → simpan ke SessionData
      _sessionData.loadFromDatabase(user);

      // Pindah ke halaman utama
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainWrapper()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat login: $e"),
          backgroundColor: accentColor,
        ),
      );
    }
  }

  // -------------------------------------------------
  //                         UI
  // -------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text(
          'LOG - IN FORM',
          style: GoogleFonts.fredoka(color: primaryColor),
        ),
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Deskripsi singkat
            Text(
              'Please log - in to continue to the App!',
              style: GoogleFonts.didactGothic(
                fontSize: 16,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 30),

            // USERNAME
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Username =',
                style: GoogleFonts.didactGothic(
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            RoundedInputField(
              controller: _usernameController,
              hintText: 'Insert Your Username Here!',
            ),
            const SizedBox(height: 20),

            // EMAIL (optional visual only)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email =',
                style: GoogleFonts.didactGothic(
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            RoundedInputField(
              controller: _emailController,
              hintText: 'Insert Your Email Here!',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // PASSWORD
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password =',
                style: GoogleFonts.didactGothic(
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RoundedInputField(
                    controller: _passwordController,
                    hintText: 'Insert Your Password Here!',
                    obscureText: _obscurePassword,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),

            // LOGO (opsional, sama seperti sebelumnya)
            Center(
              child: Image.asset(
                'assets/bread_icon.png',
                height: 120,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.cake, size: 120, color: primaryColor),
              ),
            ),
            const SizedBox(height: 40),

            // BUTTON LOGIN
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'LOG - IN NOW !',
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Info kecil
            Center(
              child: Text(
                'Pastikan username & password sudah benar.',
                style: GoogleFonts.didactGothic(
                  fontSize: 14,
                  color: primaryColor.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
