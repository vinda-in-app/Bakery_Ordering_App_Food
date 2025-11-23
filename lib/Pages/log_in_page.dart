import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_theme.dart';
import '../Widgets/rounded_input.dart';
import '../DB/user_database.dart';
import '../Models/user_model.dart';
import 'main_wrapper.dart'; // Untuk navigasi ke MainWrapper

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // Controller untuk mengambil input dari user
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Controller tambahan untuk email

  // Akses instance SessionData dan UserDatabase
  final SessionData _sessionData = SessionData();
  final UserDatabase _userDatabase = UserDatabase();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Mengisi otomatis untuk tujuan demo/testing
    if (_userDatabase.mockDatabase.containsKey('pelanggansetia')) {
      _usernameController.text = 'pelanggansetia';
      _passwordController.text = '123456';
      _emailController.text = 'pelanggan@email.com';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  void _handleLogin() {
    try {
      final String username = _usernameController.text.trim();
      final String password = _passwordController.text;

      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username dan Password wajib diisi!')),
        );
        return;
      }

      final userData = _userDatabase.mockDatabase[username];

      if (userData != null && userData.password == password) {
        _sessionData.loadFromDatabase(userData);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Gagal123: Username atau Password salah.'),
            backgroundColor: accentColor,
          ),
        );
      }
    }
    catch (e) {
      print('Login error: ${e.toString()}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),

            // Judul LOG - IN FORM
            Text(
              'LOG - IN FORM',
              style: GoogleFonts.fredoka(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please log - in to continue to the App!',
              style: GoogleFonts.didactGothic(
                fontSize: 16,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 50),

            // INPUT USERNAME
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Username =',
                style: GoogleFonts.didactGothic(fontSize: 18, color: primaryColor),
              ),
            ),
            const SizedBox(height: 8),
            RoundedInputField(
              controller: _usernameController,
              hintText: 'Insert Your Username Here!',
            ),
            const SizedBox(height: 20),

            // INPUT EMAIL (Opsional, tapi ada di mockup login)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email =',
                style: GoogleFonts.didactGothic(fontSize: 18, color: primaryColor),
              ),
            ),
            const SizedBox(height: 8),
            RoundedInputField(
              controller: _emailController, // Menggunakan controller baru
              hintText: 'Insert Your Email Here!',
            ),
            const SizedBox(height: 20),

            // INPUT PASSWORD
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password =',
                style: GoogleFonts.didactGothic(fontSize: 18, color: primaryColor),
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
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
            const SizedBox(height: 60),

            // LOGO & TEXT
            Image.asset(
              'assets/bread_icon.png', // Gantilah dengan path ikon roti Anda
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                // Placeholder jika gambar tidak ditemukan
                return const Icon(Icons.cake, size: 120, color: primaryColor);
              },
            ),
            const SizedBox(height: 15),
            Text(
              'COZY',
              style: GoogleFonts.fredoka(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              'OVEN',
              style: GoogleFonts.fredoka(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              'BAKERY',
              style: GoogleFonts.fredoka(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 50),

            // LOG IN NOW BUTTON
            GestureDetector(
              onTap: _handleLogin,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: secondaryColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'LOG - IN NOW !',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                    letterSpacing: 2,
                  ),
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
