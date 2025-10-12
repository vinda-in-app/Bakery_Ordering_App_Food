import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_theme.dart';
import '../Models/user_model.dart';
import 'main_wrapper.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Ambil session singleton
    final session = SessionData();

    // 🔹 Hitung total dan pajak
    double subtotal = 0;
    for (var item in session.shoppingCart) {
      subtotal += (item['item']['price'] ?? 0) * (item['quantity'] ?? 1);
    }
    double ppn = subtotal * 0.10;
    double grandTotal = subtotal + ppn;

    // 🔹 Fungsi bantu untuk card
    Widget _buildDetailCard({
      required String title,
      required String value,
      required Color color,
      required Color textColor,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.didactGothic(color: textColor, fontSize: 16)),
            Text(value, style: GoogleFonts.fredoka(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    final mainWrapperState = context.findAncestorStateOfType<MainWrapperState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('PROCESS PAYMENT', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Detail Pembayaran Anda:',
                style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 15),

            _buildDetailCard(
                title: 'Total Belanja',
                value: 'Rp. ${subtotal.toStringAsFixed(0)},-',
                color: primaryColor,
                textColor: secondaryColor),
            _buildDetailCard(
                title: 'PPN (10%)',
                value: 'Rp. ${ppn.toStringAsFixed(0)},-',
                color: primaryColor.withOpacity(0.8),
                textColor: secondaryColor),
            _buildDetailCard(
                title: 'Metode Pembayaran',
                value: session.selectedPaymentMethod,
                color: primaryColor,
                textColor: secondaryColor),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL DIBAYAR:',
                      style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w900, color: primaryColor)),
                  Text('Rp. ${grandTotal.toStringAsFixed(0)},-',
                      style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w900, color: primaryColor)),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: Text('--- Simulasi Pembayaran ---',
                  style: GoogleFonts.didactGothic(color: primaryColor, fontStyle: FontStyle.italic)),
            ),
            const SizedBox(height: 10),

            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: primaryColor, width: 3),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_2, size: 100, color: primaryColor),
                    Text('SCAN QRIS / MASUKKAN DETAIL KARTU',
                        style: GoogleFonts.didactGothic(color: primaryColor, fontWeight: FontWeight.bold)),
                    Text('JANGAN TUTUP APLIKASI SELAMA PROSES',
                        style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 12)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pembayaran Sukses! Pesanan Anda sedang diproses.'),
                    backgroundColor: primaryColor,
                  ),
                );

                // 🔹 Hapus keranjang setelah bayar
                session.updateCart([]);

                Navigator.pop(context);
                mainWrapperState?.setState(() {
                  mainWrapperState.selectedIndex = 3;
                });
              },
              child: Text('BAYAR SEKARANG!', style: GoogleFonts.fredoka(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
