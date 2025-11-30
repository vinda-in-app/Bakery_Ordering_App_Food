import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/user_model.dart';
import '../Theme/app_theme.dart';
import 'main_wrapper.dart';
import 'payment_page.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final sessionData = SessionData();

  // =============================
  //  SAFE SUBTOTAL CALCULATION
  // =============================
  double get subtotal {
    double total = 0;

    for (var item in sessionData.shoppingCart) {
      final product = item['item'];

      if (product is Map<String, dynamic>) {
        final price = product['price'] ?? 0;
        final qty = item['quantity'] ?? 1;

        total += (price * qty);
      }
    }
    return total;
  }

  // =============================
  //  MAIN ORDER INFO WIDGET
  // =============================
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
                Text(
                  title,
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.didactGothic(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================
  //  SECTION TITLE
  // =============================
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.fredoka(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: primaryColor,
        ),
      ),
    );
  }

  // =============================
  //  REUSABLE CARD SECTION
  // =============================
  Widget _buildCardSection({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
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

  // =============================
  //  CONFIRM ORDER
  // =============================
  void _confirmOrder() {
    // Kalau keranjang kosong, kasih info dan tidak lanjut
    if (sessionData.shoppingCart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang masih kosong')),
      );
      return;
    }

    // Lanjut ke halaman pembayaran
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PaymentPage(),
      ),
    );
  }

  // =============================
  //  MAIN UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ORDER SUMMARY',
            style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: baseColor.withOpacity(0.9),
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =============================
            //  CUSTOMER INFO (from Session)
            // =============================
            _buildSectionTitle('Customer Information'),
            _buildInfoContainer(
              'Customer Name',
              sessionData.name,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 10),
            _buildInfoContainer(
              'Customer Address',
              sessionData.address,
              icon: Icons.location_on_outlined,
            ),

            // =============================
            //  ORDER DETAILS
            // =============================
            _buildSectionTitle('Order Details'),
            _buildCardSection(
              title: 'Items Ordered',
              content: Column(
                children: [
                  if (sessionData.shoppingCart.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No items in the cart.',
                        style: GoogleFonts.didactGothic(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    ...sessionData.shoppingCart.map((cartItem) {
                      final product = cartItem['item'] as Map<String, dynamic>?;
                      if (product == null) return const SizedBox.shrink();

                      final name = product['name'] ?? 'Unknown Item';
                      final price = product['price'] ?? 0;
                      final quantity = cartItem['quantity'] ?? 1;

                      final totalPrice = price * quantity;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '$name  x $quantity',
                                style: GoogleFonts.didactGothic(
                                  color: primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              'Rp ${totalPrice.toStringAsFixed(0)},-',
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
                ],
              ),
            ),

            // =============================
            //  PAYMENT SUMMARY
            // =============================
            _buildSectionTitle('Payment Summary'),
            _buildCardSection(
              title: 'Payment Details',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRow('Subtotal', subtotal),
                  _buildPriceRow('Tax (10%)', subtotal * 0.10),
                  const Divider(),
                  _buildPriceRow('Total', subtotal * 1.10, bold: true),
                  const SizedBox(height: 12),
                  Text(
                    'Payment Method: ${sessionData.selectedPaymentMethod}',
                    style: GoogleFonts.didactGothic(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🟩 CONFIRM BUTTON
            ElevatedButton(
              onPressed:
              sessionData.shoppingCart.isEmpty ? null : _confirmOrder,
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

  // =============================
  //  PRICE ROW WIDGET
  // =============================
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
