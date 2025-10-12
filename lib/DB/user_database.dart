import '../Models/user_model.dart';

/// --- MOCK DATABASE (SINGLETON) ---
/// Kelas ini mensimulasikan database yang menyimpan semua akun pengguna.
/// Di aplikasi nyata, ini adalah Firebase/SQL/server API.
class UserDatabase {
  // Singleton setup
  static final UserDatabase _instance = UserDatabase._internal();
  factory UserDatabase() { return _instance; }
  UserDatabase._internal();

  /// Map yang menyimpan semua akun, di mana Key adalah username (lowercase).
  final Map<String, UserModel> mockDatabase = {
    'pelanggansetia': UserModel(
      name: "Pelanggan Setia",
      username: "pelanggansetia",
      email: "pelanggan@email.com",
      password: "123", // Password untuk akun mock
      address: "Jl. Kenari Raya, RT. 005 / RW. 007, Poris Jaya, Kec. Batuceper, Kota Tangerang, Banten 15122",
      gender: "Women (Mock)",
      birthdate: "01/01/1990 (Mock)",
      birthplace: "Jakarta (Mock)",
      userPoints: 1250,
      shoppingCart: [],
      selectedPaymentMethod: 'Debit',
    ),
  };

  /// Metode untuk menambahkan pengguna baru ke database mock
  void addUser(UserModel user) {
    mockDatabase[user.username.toLowerCase()] = user;
  }

  /// Metode untuk mencari pengguna berdasarkan username
  UserModel? findUser(String username) {
    return mockDatabase[username.toLowerCase()];
  }
}

