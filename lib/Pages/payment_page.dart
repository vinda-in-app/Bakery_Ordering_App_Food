// lib/Pages/payment_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_theme.dart';
import '../Models/user_model.dart';
import 'main_wrapper.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final SessionData sessionData = SessionData();
  late String _selectedMethod;

  // =========================================
  //  HITUNG TOTAL DARI shoppingCart (flexible)
  // =========================================
  double _calculateTotal() {
    double total = 0;

    for (final cartItem in sessionData.shoppingCart) {
      // Bisa dua bentuk:
      // 1) { 'item': { ... , 'price': x }, 'quantity': q }
      // 2) { 'price': x, 'quantity': q }
      num priceNum = 0;
      int qty = 1;

      if (cartItem is Map<String, dynamic>) {
        // Ambil quantity dulu
        final dynamic q = cartItem['quantity'] ?? 1;
        if (q is int) {
          qty = q;
        } else if (q is num) {
          qty = q.toInt();
        }

        if (cartItem['item'] is Map<String, dynamic>) {
          // Bentuk 1: produk di dalam 'item'
          final product = cartItem['item'] as Map<String, dynamic>;
          priceNum = product['price'] ?? 0;
        } else {
          // Bentuk 2: langsung ada key 'price'
          priceNum = cartItem['price'] ?? 0;
        }
      }

      total += priceNum.toDouble() * qty;
    }

    return total;
  }

  @override
  void initState() {
    super.initState();
    // kalau sudah ada metode di session, pakai itu, kalau tidak default "Cash"
    _selectedMethod = sessionData.selectedPaymentMethod.isNotEmpty
        ? sessionData.selectedPaymentMethod
        : 'Cash';
  }

  void _handlePayment() {
    final double total = _calculateTotal();
    if (total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Total pembayaran masih 0. Pastikan keranjang tidak kosong.',
            style: GoogleFonts.didactGothic(),
          ),
        ),
      );
      return;
    }

    // Simpan pilihan metode pembayaran ke session
    sessionData.selectedPaymentMethod = _selectedMethod;

    // (optional) bisa update points, dll
    // contoh: tambah poin berdasarkan total
    sessionData.userPoints += total * 0.01; // 1% dari total sebagai poin

    // Clear keranjang setelah bayar
    sessionData.shoppingCart.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Payment Success',
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        content: Text(
          'Terima kasih, pesanan kamu sedang diproses.\n\n'
              'Metode pembayaran: $_selectedMethod',
          style: GoogleFonts.didactGothic(
            fontSize: 16,
            color: primaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Kembali ke main / home, hapus history
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainWrapper()),
                    (route) => false,
              );
            },
            child: Text(
              'OK',
              style: GoogleFonts.fredoka(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double total = _calculateTotal();

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        title: Text(
          'PAYMENT',
          style: GoogleFonts.fredoka(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // ===== CARD TOTAL =====
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total to Pay',
                      style: GoogleFonts.didactGothic(
                        fontSize: 16,
                        color: primaryColor.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      'Rp ${total.toStringAsFixed(0)}',
                      style: GoogleFonts.fredoka(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Metode: $_selectedMethod',
                  style: GoogleFonts.didactGothic(
                    fontSize: 14,
                    color: primaryColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // ===== LIST METODE PEMBAYARAN =====
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView(
                children: [
                  Text(
                    'Choose Payment Method',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _PaymentMethodTile(
                    title: 'Cash',
                    subtitle: 'Bayar langsung di kasir / COD',
                    value: 'Cash',
                    groupValue: _selectedMethod,
                    icon: Icons.payments_outlined,
                    onChanged: (val) {
                      setState(() {
                        _selectedMethod = val!;
                      });
                    },
                  ),
                  _PaymentMethodTile(
                    title: 'Debit',
                    subtitle: 'Kartu debit / ATM',
                    value: 'Debit',
                    groupValue: _selectedMethod,
                    icon: Icons.credit_card,
                    onChanged: (val) {
                      setState(() {
                        _selectedMethod = val!;
                      });
                    },
                  ),
                  _PaymentMethodTile(
                    title: 'E-Wallet',
                    subtitle: 'OVO / GoPay / Dana / lainnya',
                    value: 'E-Wallet',
                    groupValue: _selectedMethod,
                    icon: Icons.account_balance_wallet_outlined,
                    onChanged: (val) {
                      setState(() {
                        _selectedMethod = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // ===== BUTTON BAYAR SEKARANG =====
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: total <= 0 ? null : _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: baseColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  'BAYAR SEKARANG!',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _PaymentMethodTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? primaryColor : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: primaryColor,
        title: Text(
          title,
          style: GoogleFonts.fredoka(
            fontSize: 16,
            color: primaryColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.didactGothic(
            fontSize: 13,
            color: primaryColor.withOpacity(0.7),
          ),
        ),
        secondary: Icon(icon, color: primaryColor),
      ),
    );
  }
}
