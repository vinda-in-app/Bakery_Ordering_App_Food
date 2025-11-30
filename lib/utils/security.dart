// lib/utils/security.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
