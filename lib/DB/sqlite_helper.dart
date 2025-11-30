// lib/DB/sqlite_helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../Models/user_model.dart';

class SQLiteHelper {
  static final SQLiteHelper _instance = SQLiteHelper._internal();
  factory SQLiteHelper() => _instance;
  SQLiteHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "app_database.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        username TEXT UNIQUE,
        email TEXT,
        password TEXT,
        address TEXT,
        gender TEXT,
        birthdate TEXT,
        birthplace TEXT,
        userPoints REAL,
        shoppingCart TEXT,
        selectedPaymentMethod TEXT
      )
    ''');
    // Bisa insert seed/mock user jika perlu
  }

  // Insert user
  Future<int> insertUser(UserModel user) async {
    final database = await db;
    return await database.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  // Get user by username (case-insensitive)
  Future<UserModel?> getUserByUsername(String username) async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      'users',
      where: 'LOWER(username) = ?',
      whereArgs: [username.toLowerCase()],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Update user (e.g. save shoppingCart, points)
  Future<int> updateUser(UserModel user) async {
    final database = await db;
    return await database.update(
      'users',
      user.toMap(),
      where: 'LOWER(username) = ?',
      whereArgs: [user.username.toLowerCase()],
    );
  }

  // Optional: delete
  Future<int> deleteUser(String username) async {
    final database = await db;
    return await database.delete('users', where: 'LOWER(username) = ?', whereArgs: [username.toLowerCase()]);
  }
}
