import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = FlutterSecureStorage();

  Future<String?> readKey(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print("Error reading from secure storage: $e");
      return null;
    }
  }

  Future<void> writeKey(String key, String? value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print("Error writing to secure storage: $e");
    }
  }

  Future<void> deleteKey(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print("Error deleting from secure storage: $e");
    }
  }
}
