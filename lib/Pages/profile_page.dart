import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_theme.dart';
import '../Models/user_model.dart';

/// ✅ Inisialisasi session global
final sessionData = SessionData();

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildProfileInfo(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: secondaryColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.didactGothic(
                        color: secondaryColor.withOpacity(0.7),
                        fontSize: 12)),
                Text(value,
                    style: GoogleFonts.didactGothic(
                        color: secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('USER PROFILE',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              child: Text(
                sessionData.name.substring(0, 1),
                style: GoogleFonts.fredoka(fontSize: 40, color: secondaryColor),
              ),
            ),
            const SizedBox(height: 10),
            Text(sessionData.name,
                style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
            Text(sessionData.email,
                style: GoogleFonts.didactGothic(
                    fontSize: 16, color: primaryColor.withOpacity(0.7))),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: primaryColor, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    'Poin Loyalitas Anda: ${sessionData.userPoints.toStringAsFixed(0)}',
                    style: GoogleFonts.fredoka(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildProfileInfo('Nama Lengkap', sessionData.name, Icons.person),
            _buildProfileInfo('Username', sessionData.username, Icons.badge),
            _buildProfileInfo('Email', sessionData.email, Icons.email),
            _buildProfileInfo('Address', sessionData.address, Icons.home),
            _buildProfileInfo('Gender', sessionData.gender, Icons.face),
            _buildProfileInfo('Birthdate', sessionData.birthdate, Icons.calendar_today),
            _buildProfileInfo('Birthplace', sessionData.birthplace, Icons.location_city),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                sessionData.clearSession(); // ✅ Tambahkan juga agar logout bersih
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
              child: Text('LOG OUT', style: GoogleFonts.fredoka(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
