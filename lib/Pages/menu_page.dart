import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_theme.dart';
import '../DB/user_database.dart';
import '../Models/user_model.dart';
import 'main_wrapper.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'BREAD';
  final UserDatabase _userDatabase = UserDatabase();
  final SessionData _sessionData = SessionData();

  // Menambahkan item ke keranjang
  void _addItemToCart(Map<String, dynamic> item) {
    setState(() {
      final index = _sessionData.shoppingCart.indexWhere(
            (cartItem) => cartItem['name'] == item['name'],
      );

      if (index != -1) {
        _sessionData.shoppingCart[index]['quantity'] += 1;
      } else {
        _sessionData.shoppingCart.add({
          'name': item['name'],
          'price': item['price'],
          'quantity': 1,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} berhasil ditambahkan ke keranjang!'),
        backgroundColor: primaryColor,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  // Menampilkan daftar item per kategori
  Widget _buildItemList() {
    final filteredItems = _sessionData.mockMenu
        .where((item) => item['category'] == selectedCategory)
        .toList();

    return Column(
      children: filteredItems.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: primaryColor, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ikon kategori
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item['icon'],
                      color: primaryColor,
                      size: 38,
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Info item
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['desc'],
                          style: GoogleFonts.didactGothic(
                            fontSize: 14,
                            color: primaryColor.withOpacity(0.8),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rp ${item['price'].toStringAsFixed(0)},-',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _addItemToCart(item),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 28),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Daftar kategori
  final List<String> _categories = [
    'BREAD',
    'FILLED BUN',
    'CROISSANT',
    'BAGEL',
    'COOKIE',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            toolbarHeight: 180,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              centerTitle: true,
              title: Container(
                color: primaryColor,
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PICK - UP ORDER',
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: baseColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 4.0, bottom: 12.0),
                      child: Text(
                        '( Baca Lokasi Sekarang di Maps )',
                        style: GoogleFonts.didactGothic(
                          fontSize: 14,
                          color: baseColor.withOpacity(0.9),
                        ),
                      ),
                    ),
                    // Search Bar
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.brown),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Search your Preferred Order',
                                style: GoogleFonts.didactGothic(
                                    color: Colors.brown.withOpacity(0.6)),
                              ),
                            ),
                            const Icon(Icons.mic, color: Colors.brown),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Konten Utama
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sidebar kategori
                    Column(
                      children: _categories.map((category) {
                        final isSelected = category == selectedCategory;

                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedCategory = category);
                          },
                          child: Container(
                            width: 100,
                            margin:
                            const EdgeInsets.only(bottom: 15, left: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected
                                    ? secondaryColor
                                    : primaryColor,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  _sessionData.mockMenu
                                      .firstWhere(
                                          (e) =>
                                      e['category'] == category,
                                      orElse: () => {
                                        'icon': Icons.fastfood
                                      })['icon'] ??
                                      Icons.fastfood,
                                  color: isSelected
                                      ? baseColor
                                      : primaryColor,
                                  size: 35,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  category,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.didactGothic(
                                    color: isSelected
                                        ? baseColor
                                        : primaryColor,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // Daftar Item
                    Expanded(
                      child: _buildItemList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
    );
  }
}
