// lib/Pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_theme.dart';
import '../Models/user_model.dart';
import 'log_in_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionData();

    // Handle nama kosong supaya tidak crash saat ambil initial
    final String displayName =
    session.name.isNotEmpty ? session.name : 'Guest';
    final String initial = displayName[0].toUpperCase();

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        title: Text(
          'PROFILE PAGE',
          style: GoogleFonts.fredoka(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // AVATAR + NAMA
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              child: Text(
                initial,
                style: GoogleFonts.fredoka(
                  fontSize: 40,
                  color: secondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '@${session.username}',
              style: GoogleFonts.didactGothic(
                fontSize: 16,
                color: primaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),

            // INFO LIST
            _ProfileInfoTile(
              title: 'Email',
              value: session.email,
              icon: Icons.email_outlined,
            ),
            _ProfileInfoTile(
              title: 'Alamat',
              value: session.address,
              icon: Icons.home_outlined,
            ),
            _ProfileInfoTile(
              title: 'Jenis Kelamin',
              value: session.gender,
              icon: Icons.person_outline,
            ),
            _ProfileInfoTile(
              title: 'Tempat Lahir',
              value: session.birthplace,
              icon: Icons.location_city_outlined,
            ),
            _ProfileInfoTile(
              title: 'Tanggal Lahir',
              value: session.birthdate,
              icon: Icons.cake_outlined,
            ),
            _ProfileInfoTile(
              title: 'Points',
              value: session.userPoints.toString(),
              icon: Icons.stars_outlined,
            ),
            _ProfileInfoTile(
              title: 'Metode Pembayaran',
              value: session.selectedPaymentMethod,
              icon: Icons.payment_outlined,
            ),

            const SizedBox(height: 32),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: Text(
                  'LOG OUT',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  // Bersihkan session
                  SessionData().clearSession();

                  // Arahkan ke halaman login, hapus semua history
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LogInPage(),
                    ),
                        (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ProfileInfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final String displayValue = value.isNotEmpty ? value : '-';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.didactGothic(
                    fontSize: 14,
                    color: primaryColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayValue,
                  style: GoogleFonts.didactGothic(
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
