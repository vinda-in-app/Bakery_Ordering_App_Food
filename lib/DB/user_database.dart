// lib/DB/user_database.dart
import 'dart:async';

import '../Models/user_model.dart';
import 'sqlite_helper.dart';

/// UserDatabase sekarang jadi wrapper untuk SQLite,
/// tetap pakai pola Singleton supaya gampang dipanggil.
class UserDatabase {
  // Singleton setup
  static final UserDatabase _instance = UserDatabase._internal();
  factory UserDatabase() => _instance;
  UserDatabase._internal();

  final SQLiteHelper _sqliteHelper = SQLiteHelper();

  // ---------------------------------------------------
  //   OPTIONAL: Seed user default "pelanggansetia"
  //   (supaya perilaku mirip mockDatabase lama)
  // ---------------------------------------------------
  Future<void> _ensureSeedUser() async {
    const defaultUsername = 'pelanggansetia';

    final existing = await _sqliteHelper.getUserByUsername(defaultUsername);
    if (existing != null) return;

    final UserModel defaultUser = UserModel(
      name: 'Pelanggan Setia',
      username: 'pelanggansetia',
      email: 'pelanggan@email.com',
      // NOTE: sekarang masih password mentah
      // kalau nanti pakai hashPassword(), ganti bagian ini.
      password: '123456',
      address:
      'Jl. Kenari Raya, RT.005/RW.007, Poris Jaya, Kota Tangerang, Banten',
      gender: 'Female',
      birthdate: '2000-01-01',
      birthplace: 'Jakarta',
      userPoints: 250.0,
      shoppingCart: <Map<String, dynamic>>[],
      selectedPaymentMethod: 'Debit',
    );

    await _sqliteHelper.insertUser(defaultUser);
  }

  // ---------------------------------------------------
  //           API PENGGANTI MOCK DATABASE
  // ---------------------------------------------------

  /// Tambah user baru ke SQLite (pengganti addUser di mockDatabase)
  Future<int> addUser(UserModel user) async {
    await _ensureSeedUser(); // opsional, boleh dihapus kalau nggak perlu seed
    return await _sqliteHelper.insertUser(user);
  }

  /// Cari user berdasarkan username (pengganti findUser di mockDatabase)
  Future<UserModel?> findUser(String username) async {
    await _ensureSeedUser(); // opsional
    return await _sqliteHelper.getUserByUsername(username);
  }

  /// Ambil semua user dari tabel `users`
  Future<List<UserModel>> getAllUsers() async {
    final db = await _sqliteHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return maps.map((map) => UserModel.fromMap(map)).toList();
  }
}
