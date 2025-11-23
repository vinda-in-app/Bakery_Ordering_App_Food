import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_theme.dart';
import '../Models/user_model.dart';
import 'main_wrapper.dart'; // Untuk navigasi tab

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Widget kartu layanan (Pick Up / Delivery)
  Widget _serviceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isAvailable,
    VoidCallback? onTap,
  }) {
    final SessionData sessionData = SessionData();
    final bool isDelivery = title == 'Delivery';

    return GestureDetector(
      onTap: isAvailable
          ? () {
        // Jika Pick Up, langsung navigasi ke Menu Page (Index 1)
        if (!isDelivery) {
          mainWrapperState?.changeTab(1);
        } else {
          // Tampilkan pesan Coming Soon untuk Delivery
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title - $subtitle'),
              backgroundColor: secondaryColor,
            ),
          );
        }
      }
          : null, // Nonaktifkan onTap jika tidak tersedia
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isAvailable ? primaryColor.withOpacity(0.9) : primaryColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: secondaryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status COMING SOON!
            if (!isAvailable)
              Text(
                'COMING SOON!',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            if (!isAvailable) const SizedBox(height: 5),

            Row(
              children: [
                Icon(icon, size: 40, color: baseColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: baseColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: GoogleFonts.didactGothic(
                fontSize: 16,
                color: baseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SessionData sessionData = SessionData();

    return Scaffold(
      backgroundColor: baseColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Bagian Welcome dan Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME DEAR,',
                      style: GoogleFonts.fredoka(
                        fontSize: 29,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      '"${sessionData.name}"',
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.monetization_on, size: 40, color: secondaryColor),
                    Text(
                      '${sessionData.userPoints.toStringAsFixed(0)} Points',
                      style: GoogleFonts.didactGothic(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),
            Text(
              'Choose your Services Here!',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 15),

            // Grid Layanan (Pick Up & Delivery)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pick Up Service (Aktif)
                Expanded(
                  child: _serviceCard(
                    context: context,
                    icon: Icons.store,
                    title: 'Pick Up',
                    subtitle: 'Ambil pesanan Anda langsung di toko secara langsung.',
                    isAvailable: true,
                  ),
                ),
                const SizedBox(width: 15),
                // Delivery Service (Coming Soon)
                Expanded(
                  child: _serviceCard(
                    context: context,
                    icon: Icons.delivery_dining,
                    title: 'Delivery',
                    subtitle: 'Layanan pengiriman sedang dipersiapkan.',
                    isAvailable: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Bagian Vouchers
            Text(
              'Your Vouchers =',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: primaryColor, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    'COMING SOON!',
                    style: GoogleFonts.fredoka(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voucher sedang disiapkan!'),
                          backgroundColor: secondaryColor,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'USE NOW!',
                      style: GoogleFonts.fredoka(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Bagian About Us dan Customer Service
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // About Us
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: secondaryColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.business, size: 30, color: baseColor),
                        const SizedBox(height: 5),
                        Text(
                          'ABOUT OUR BAKERY',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: baseColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Customer Service
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: secondaryColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.headset_mic, size: 30, color: baseColor),
                        const SizedBox(height: 5),
                        Text(
                          'CUSTOMER SERVICE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: baseColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
