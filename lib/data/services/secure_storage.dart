import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton instance
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  // when calling SecureStorageService(),
  // it does not create a new object but returns the previously initialized _instance.
  factory SecureStorageService() => _instance;

  // private constructor
  SecureStorageService._internal();

  final _storage = const FlutterSecureStorage();

  /// Save a key-value pair
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read value by key
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete value by key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all keys
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
