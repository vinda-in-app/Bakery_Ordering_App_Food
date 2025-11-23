import 'package:flutter/material.dart';

/// Model untuk menyimpan data detail pengguna (dipakai di database dan session)
class UserModel {
  final String name;
  final String username;
  final String email;
  final String password; // Disimpan di database mock, tidak disarankan untuk real app
  final String address;
  final String gender;
  final String birthdate;
  final String birthplace;
  final double userPoints;

  // Data transaksi yang disalin dari session saat checkout
  final List<Map<String, dynamic>> shoppingCart;
  final String selectedPaymentMethod;

  UserModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.address,
    required this.gender,
    required this.birthdate,
    required this.birthplace,
    required this.userPoints,
    required this.shoppingCart,
    required this.selectedPaymentMethod,
  });

  // Metode untuk membuat salinan data dengan pembaruan
  UserModel copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
    String? address,
    String? gender,
    String? birthdate,
    String? birthplace,
    double? userPoints,
    List<Map<String, dynamic>>? shoppingCart,
    String? selectedPaymentMethod,
  }) {
    return UserModel(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      birthplace: birthplace ?? this.birthplace,
      userPoints: userPoints ?? this.userPoints,
      shoppingCart: shoppingCart ?? this.shoppingCart,
      selectedPaymentMethod:
      selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }
}

/// --- SESSION DATA (SINGLETON) ---
/// Digunakan untuk menyimpan data pengguna yang sedang login
class SessionData {
  String name = "Guest";
  String username = "";
  String email = "";
  String password = "";
  String address =
      "Jl. Kenari Raya, RT. 005 / RW. 007, Poris Jaya, Kec. Batuceper, Kota Tangerang, Banten 15122";
  String gender = "";
  String birthdate = "";
  String birthplace = "";
  double userPoints = 0;

  // Keranjang belanja dan metode pembayaran disimpan di session
  List<Map<String, dynamic>> shoppingCart = [];
  String selectedPaymentMethod = 'Debit';

  // Daftar Item Menu (Dianggap statis/global)
  final List<Map<String, dynamic>> mockMenu = const [
    // BREAD
    {
      'category': 'BREAD',
      'name': 'White Bread Loaf',
      'desc': 'Roti tawar klasik, lembut.',
      'price': 15000,
      'icon': Icons.bakery_dining
    },
    {
      'category': 'BREAD',
      'name': 'Wheat Bread Loaf',
      'desc': 'Roti gandum, tinggi serat.',
      'price': 20000,
      'icon': Icons.bakery_dining
    },
    {
      'category': 'BREAD',
      'name': 'Focaccia Bread',
      'desc': 'Roti Italia dengan minyak zaitun.',
      'price': 45000,
      'icon': Icons.bakery_dining
    },
    {
      'category': 'BREAD',
      'name': 'Baguette',
      'desc': 'Roti panjang Perancis, kulit renyah.',
      'price': 35000,
      'icon': Icons.bakery_dining
    },
    {
      'category': 'BREAD',
      'name': 'English Muffins',
      'desc': 'Roti bundar untuk Eggs Benedict.',
      'price': 25000,
      'icon': Icons.bakery_dining
    },

    // FILLED BUN
    {
      'category': 'FILLED BUN',
      'name': 'Chocolate Filled Bun',
      'desc': 'Roti manis dengan isian cokelat.',
      'price': 5000,
      'icon': Icons.donut_large
    },
    {
      'category': 'FILLED BUN',
      'name': 'Cheese Filled Bun',
      'desc': 'Roti manis dengan isian keju.',
      'price': 5000,
      'icon': Icons.donut_large
    },
    {
      'category': 'FILLED BUN',
      'name': 'Coconut Filled Bun',
      'desc': 'Roti manis dengan isian kelapa.',
      'price': 6000,
      'icon': Icons.donut_large
    },
    {
      'category': 'FILLED BUN',
      'name': 'Strawberry Filled Bun',
      'desc': 'Roti manis dengan isian stroberi.',
      'price': 5000,
      'icon': Icons.donut_large
    },
    {
      'category': 'FILLED BUN',
      'name': 'Raisin Bun',
      'desc': 'Roti kismis manis.',
      'price': 7000,
      'icon': Icons.donut_large
    },

    // CROISSANT
    {
      'category': 'CROISSANT',
      'name': 'Plain/Butter Croissant',
      'desc': 'Pastry Perancis klasik, kaya mentega.',
      'price': 15000,
      'icon': Icons.restaurant_menu
    },
    {
      'category': 'CROISSANT',
      'name': 'Pain au Chocolat',
      'desc': 'Croissant isi cokelat.',
      'price': 25000,
      'icon': Icons.restaurant_menu
    },
    {
      'category': 'CROISSANT',
      'name': 'Almond Croissant',
      'desc': 'Croissant isi krim almond, dipanggang dua kali.',
      'price': 35000,
      'icon': Icons.restaurant_menu
    },
    {
      'category': 'CROISSANT',
      'name': 'Ham and Cheese Croissant',
      'desc': 'Croissant gurih isi ham dan keju.',
      'price': 30000,
      'icon': Icons.restaurant_menu
    },
    {
      'category': 'CROISSANT',
      'name': 'Pain aux Raisins',
      'desc': 'Pastry spiral isi custard dan kismis.',
      'price': 25000,
      'icon': Icons.restaurant_menu
    },

    // BAGEL
    {
      'category': 'BAGEL',
      'name': 'Plain Bagel',
      'desc': 'Bagel dasar, direbus dan dipanggang.',
      'price': 15000,
      'icon': Icons.lens_outlined
    },
    {
      'category': 'BAGEL',
      'name': 'Sesame Bagel',
      'desc': 'Bagel dengan taburan wijen.',
      'price': 20000,
      'icon': Icons.lens_outlined
    },
    {
      'category': 'BAGEL',
      'name': 'Everything Bagel',
      'desc': 'Bagel dengan segala jenis bumbu.',
      'price': 25000,
      'icon': Icons.lens_outlined
    },
    {
      'category': 'BAGEL',
      'name': 'Blueberry Bagel',
      'desc': 'Bagel manis dengan blueberry kering.',
      'price': 20000,
      'icon': Icons.lens_outlined
    },
    {
      'category': 'BAGEL',
      'name': 'Whole Wheat Bagel',
      'desc': 'Bagel gandum utuh, lebih sehat.',
      'price': 30000,
      'icon': Icons.lens_outlined
    },

    // COOKIE
    {
      'category': 'COOKIE',
      'name': 'Chocolate Chip Cookie',
      'desc': 'Cookie klasik dengan choco chip.',
      'price': 10000,
      'icon': Icons.circle
    },
    {
      'category': 'COOKIE',
      'name': 'Oatmeal Raisin Cookie',
      'desc': 'Cookie dengan oatmeal dan kismis.',
      'price': 10000,
      'icon': Icons.circle
    },
    {
      'category': 'COOKIE',
      'name': 'Peanut Butter Cookie',
      'desc': 'Cookie dengan rasa selai kacang yang kuat.',
      'price': 10000,
      'icon': Icons.circle
    },
    {
      'category': 'COOKIE',
      'name': 'Double Chocolate Cookie',
      'desc': 'Cookie cokelat ganda yang intens.',
      'price': 10000,
      'icon': Icons.circle
    },
    {
      'category': 'COOKIE',
      'name': 'Sugar Cookie',
      'desc': 'Cookie manis polos yang mudah dihias.',
      'price': 10000,
      'icon': Icons.circle
    },
  ];

  // Singleton setup
  static final SessionData _instance = SessionData._internal();
  factory SessionData() {
    return _instance;
  }
  SessionData._internal();

  // Memuat data dari UserModel setelah berhasil login/signup
  void loadFromDatabase(UserModel user) {
    name = user.name;
    username = user.username;
    email = user.email;
    password = user.password;
    address = user.address;
    gender = user.gender;
    birthdate = user.birthdate;
    birthplace = user.birthplace;
    userPoints = user.userPoints;
    shoppingCart = user.shoppingCart;
    selectedPaymentMethod = user.selectedPaymentMethod;
  }

  // Menyimpan data keranjang ke sesi (dipanggil di MenuPage)
  void updateCart(List<Map<String, dynamic>> newCart) {
    shoppingCart = newCart;
  }

  // Mengosongkan sesi saat Log Out
  void clearSession() {
    name = "Guest";
    username = "";
    email = "";
    password = "";
    address =
    "Jl. Kenari Raya, RT. 005 / RW. 007, Poris Jaya, Kec. Batuceper, Kota Tangerang, Banten 15122";
    userPoints = 0;
    shoppingCart = [];
    selectedPaymentMethod = 'Debit';
  }
}

/// --- MOCK DATABASE / SESSION UNTUK TESTING ---
final Map<String, UserModel> mockDatabase = {
  'pelanggansetia': UserModel(
    name: 'Pelanggan Setia',
    username: 'pelanggansetia',
    email: 'pelanggan@email.com',
    password: '123456',
    address:
    'Jl. Kenari Raya, RT.005/RW.007, Poris Jaya, Kota Tangerang, Banten',
    gender: 'Perempuan',
    birthdate: '2000-01-01',
    birthplace: 'Tangerang',
    userPoints: 250.0,
    shoppingCart: [],
    selectedPaymentMethod: 'Debit',
  ),
};
