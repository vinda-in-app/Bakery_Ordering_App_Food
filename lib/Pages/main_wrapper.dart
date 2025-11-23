import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_theme.dart';
import '../Models/user_model.dart'; // Untuk SessionData
import 'home_page.dart';
import 'menu_page.dart';
import 'order_summary_page.dart';
import 'status_page.dart';
import 'profile_page.dart';

// Variabel global untuk mengakses state MainWrapper dari file lain
MainWrapperState? mainWrapperState;

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  // Catatan: Variabel ini sengaja tidak menggunakan underscore (_)
  // agar dapat diakses oleh widget lain melalui global key/state.
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    mainWrapperState = this; // Simpan instance state ke variabel global
  }

  // Metode publik untuk mengubah tab dari luar (misalnya dari HomePage)
  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Daftar halaman yang akan ditampilkan di body
  final List<Widget> _pages = const [
    HomePage(),
    MenuPage(),
    OrderSummaryPage(),
    OrderStatusPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Akses SessionData untuk menampilkan nama pengguna (Contoh)
    final sessionData = SessionData();

    return Scaffold(
      backgroundColor: baseColor,
      // Body akan menampilkan halaman yang sesuai dengan selectedIndex
      body: _pages[selectedIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: primaryColor, width: 2.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: changeTab, // Memanggil changeTab saat ikon diklik
          type: BottomNavigationBarType.fixed, // Mempertahankan semua ikon
          backgroundColor: primaryColor,
          selectedItemColor: baseColor,
          unselectedItemColor: baseColor.withOpacity(0.5),
          selectedLabelStyle: GoogleFonts.didactGothic(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.didactGothic(),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'MENU',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'CART',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'STATUS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
