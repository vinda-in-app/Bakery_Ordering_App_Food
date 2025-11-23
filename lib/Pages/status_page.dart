import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_theme.dart';

class OrderStatusPage extends StatelessWidget {
  const OrderStatusPage({super.key});

  Widget _buildStatusStep(String title, String subtitle, bool isActive, bool isCompleted) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: isCompleted ? accentColor : (isActive ? primaryColor : primaryColor.withOpacity(0.3)),
                shape: BoxShape.circle, border: Border.all(color: primaryColor, width: 2),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: secondaryColor, size: 18)
                    : Text((title[0]).toUpperCase(), style: GoogleFonts.didactGothic(color: isActive ? secondaryColor : primaryColor, fontWeight: FontWeight.bold)),
              ),
            ),
            if (!isCompleted) Container(width: 2, height: 50, color: primaryColor.withOpacity(0.5)),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.toUpperCase(), style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.bold, color: isActive || isCompleted ? primaryColor : primaryColor.withOpacity(0.6))),
              Text(subtitle, style: GoogleFonts.didactGothic(fontSize: 16, color: isActive || isCompleted ? primaryColor : primaryColor.withOpacity(0.6))),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const bool isReadyForPickup = true; // Status simulasi
    const bool isCompleted = false;

    return Scaffold(
      appBar: AppBar(title: Text('ORDER STATUS', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Status Pesanan Anda #20251011', style: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text('Layanan: Pick Up | Lokasi: Jl. Kenari Raya', style: GoogleFonts.didactGothic(fontSize: 16, color: primaryColor), textAlign: TextAlign.center),
            const SizedBox(height: 30),

            _buildStatusStep('Payment Confirmed', 'Pembayaran Anda telah diterima. Menunggu antrian dapur.', !isReadyForPickup, isReadyForPickup),
            _buildStatusStep('Being Baked', 'Roti Anda sedang dalam proses pembuatan di oven.', !isReadyForPickup, isReadyForPickup),
            _buildStatusStep('Ready for Pick Up', isReadyForPickup ? 'Pesanan Anda sudah siap diambil di lokasi.' : 'Pesanan Anda masih dalam antrian.', isReadyForPickup, isReadyForPickup),
            _buildStatusStep('Order Completed', 'Pesanan telah diambil oleh pelanggan.', isCompleted, isCompleted),
            const SizedBox(height: 40),

            if (isReadyForPickup)
              ElevatedButton(
                onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selamat menikmati! Pesanan Anda telah diambil.'), backgroundColor: accentColor)); },
                child: Text('SUDAH DIAMBIL', style: GoogleFonts.fredoka(fontSize: 20)),
              ),
            const SizedBox(height: 15),
            Text('Terima kasih telah berbelanja di The Cozy Oven Bakery!', textAlign: TextAlign.center, style: GoogleFonts.didactGothic(color: primaryColor)),
          ],
        ),
      ),
    );
  }
}
