import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/user_model.dart';
import '../Theme/app_theme.dart';
import 'main_wrapper.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final sessionData = SessionData(); // ✅ instance dari singleton

  double get subtotal {
    double total = 0;
    for (var item in sessionData.shoppingCart) {
      total += item['item']['price'] * item['quantity'];
    }
    return total;
  }

  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;

  Widget _buildInfoContainer(String title, String value, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, color: primaryColor, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
                const SizedBox(height: 4),
                Text(value,
                    style: GoogleFonts.didactGothic(
                        fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryContainer({
    required String title,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  void _confirmOrder() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Order Confirmed"),
        content: const Text("Your bakery order has been placed successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainWrapper()),
              );
            },
            child: Text("OK",
                style: GoogleFonts.fredoka(color: primaryColor, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUMMARY ORDER',
            style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor.withOpacity(0.9),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoContainer(
              'LOCATION OF PICK-UP IN =',
              sessionData.address,
              icon: Icons.location_on,
            ),
            const SizedBox(height: 15),

            // 🥐 ORDER LIST
            _buildSummaryContainer(
              title: 'ORDER SUMMARY =',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sessionData.shoppingCart.isEmpty
                    ? [
                  Text(
                    'Keranjang Anda kosong. Tambahkan item dari Menu.',
                    style: GoogleFonts.didactGothic(color: primaryColor),
                  )
                ]
                    : sessionData.shoppingCart.map((cartItem) {
                  final item =
                  cartItem['item'] as Map<String, dynamic>; // ✅ Map
                  final quantity = cartItem['quantity'] as int;
                  final totalHarga = item['price'] * quantity;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${item['name']}  x $quantity',
                            style: GoogleFonts.didactGothic(
                              color: primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          'Rp ${totalHarga.toStringAsFixed(0)},-',
                          style: GoogleFonts.fredoka(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 15),

            // 💳 PAYMENT
            _buildSummaryContainer(
              title: 'PAYMENT METHOD =',
              content: Text(
                sessionData.selectedPaymentMethod,
                style: GoogleFonts.didactGothic(color: primaryColor),
              ),
            ),
            const SizedBox(height: 15),

            // 💰 PRICE BREAKDOWN
            _buildSummaryContainer(
              title: 'PRICE DETAILS =',
              content: Column(
                children: [
                  _buildPriceRow('Subtotal', subtotal),
                  _buildPriceRow('Tax (10%)', tax),
                  const Divider(),
                  _buildPriceRow('Total', total, bold: true),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Confirm Button
            ElevatedButton(
              onPressed: sessionData.shoppingCart.isEmpty ? null : _confirmOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'CONFIRM ORDER',
                style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.didactGothic(
                  color: Colors.black87, fontSize: 14)),
          Text(
            'Rp ${value.toStringAsFixed(0)},-',
            style: GoogleFonts.fredoka(
              color: primaryColor,
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
