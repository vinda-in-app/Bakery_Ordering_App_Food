import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../Theme/app_theme.dart';
import '../DB/user_database.dart';
import '../Models/user_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'BREAD';
  final UserDatabase _userDatabase = UserDatabase();
  final SessionData _sessionData = SessionData();

  // Variabel lokasi
  Position? _currentPosition;
  String? _currentAddress = "Memuat lokasi...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ============================================
  // 🔵 Fungsi untuk mendapatkan lokasi pengguna
  // ============================================
  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentAddress = "Memuat lokasi...";
    });

    try {
      // Cek service GPS aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _currentAddress = "Layanan lokasi dimatikan");
        return;
      }

      // Cek & minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _currentAddress = "Izin lokasi ditolak");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _currentAddress = "Izin lokasi ditolak permanen");
        return;
      }

      // GPS dapat digunakan → ambil posisi
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;

      // Ambil nama alamat dari koordinat
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        setState(() {
          _currentAddress = "${place.subLocality ?? ""} ${place.locality ?? ""}, ${place.country ?? ""}";
        });
      } else {
        setState(() => _currentAddress = "Alamat tidak ditemukan");
      }
    } catch (e) {
      setState(() => _currentAddress = "Gagal memuat lokasi");
    }
  }

  // ============================================
  // 🔵 ADD ITEM TO CART
  // ============================================
  void _addItemToCart(Map<String, dynamic> item) {
    setState(() {
      final index = _sessionData.shoppingCart.indexWhere(
            (cartItem) =>
        cartItem['item'] != null &&
            cartItem['item']['name'] == item['name'],
      );

      if (index != -1) {
        _sessionData.shoppingCart[index]['quantity'] += 1;
      } else {
        _sessionData.shoppingCart.add({
          'item': item,
          'quantity': 1,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} berhasil ditambahkan ke keranjang!'),
        backgroundColor: primaryColor,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  // ============================================
  // 🔵 PRODUCT LIST
  // ============================================
  Widget _buildItemList() {
    final filteredItems = _sessionData.mockMenu
        .where((item) => item['category'] == selectedCategory)
        .toList();

    return Column(
      children: filteredItems.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: primaryColor, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ICON
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item['icon'], color: primaryColor, size: 38),
                  ),
                  const SizedBox(width: 15),

                  // TEXT INFO
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
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.didactGothic(
                            fontSize: 14,
                            color: primaryColor.withOpacity(0.8),
                          ),
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

  // CATEGORY NAMES
  final List<String> _categories = [
    'BREAD',
    'FILLED BUN',
    'CROISSANT',
    'BAGEL',
    'COOKIE',
  ];

  // ============================================
  // 🔵 UI
  // ============================================
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
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            toolbarHeight: 180,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              centerTitle: true,
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: primaryColor,
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

                    // ==============================
                    // 🔵 Lokasi saat ini
                    // ==============================
                    GestureDetector(
                      onTap: _getCurrentLocation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 12),
                        child: Text(
                          _currentAddress ?? "Klik untuk dapatkan lokasi",
                          style: GoogleFonts.didactGothic(
                            fontSize: 14,
                            color: baseColor.withOpacity(0.9),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    // ==============================
                    // SEARCH BAR
                    // ==============================
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.brown),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Search your Preferred Order',
                                style: GoogleFonts.didactGothic(
                                  color: Colors.brown.withOpacity(0.6),
                                ),
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

          // ============================================
          // BODY KATEGORI + PRODUK
          // ============================================
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SIDE CATEGORIES
                    Column(
                      children: _categories.map((category) {
                        bool isSelected = category == selectedCategory;

                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedCategory = category),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(bottom: 15, left: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                              isSelected ? primaryColor : Colors.transparent,
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
                                  _sessionData.mockMenu.firstWhere(
                                        (e) => e['category'] == category,
                                    orElse: () => {'icon': Icons.fastfood},
                                  )['icon'],
                                  color: isSelected ? baseColor : primaryColor,
                                  size: 35,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  category,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.didactGothic(
                                    color: isSelected ? baseColor : primaryColor,
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

                    // PRODUCT LIST
                    Expanded(child: _buildItemList()),
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
