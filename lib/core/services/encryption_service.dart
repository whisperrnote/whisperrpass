import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whisperrpass/core/services/secure_storage_service.dart';

class EncryptionService {
  final _secureStorageService = SecureStorageService();
  static const String keyName = 'encryptionKey';

  Future<Key> _getEncryptionKey() async {
    String? key = await _secureStorageService.readKey(keyName);
    if (key == null) {
      // Generate a new key
      final newKey = Key.fromSecureRandom(32);
      await _secureStorageService.writeKey(keyName, base64Encode(newKey.bytes));
      return newKey;
    } else {
      return Key(base64Decode(key));
    }
  }

  Future<Encrypted> encryptData(String plainText) async {
    final key = await _getEncryptionKey();
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.encrypt(plainText, iv: iv);
  }

  Future<String> decryptData(Encrypted encrypted) async {
    final key = await _getEncryptionKey();
    final iv = IV.fromSecureRandom(16); // Use a new IV for decryption
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
