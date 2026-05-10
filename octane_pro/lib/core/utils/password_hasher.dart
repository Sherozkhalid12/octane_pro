import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  /// Hash a password using SHA-256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify a password against a hash
  static bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }
}
