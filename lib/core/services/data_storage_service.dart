import 'dart:io';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisperrpass/core/services/encryption_service.dart';

class DataStorageService {
  final _encryptionService = EncryptionService();
  final String _fileName = '.whisperrpass_data.json';

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  Future<bool> dataFileExists() async {
    final path = await _getFilePath();
    final file = File(path);
    return file.exists();
  }

  Future<void> writeEncryptedData(Map<String, dynamic> data) async {
    final path = await _getFilePath();
    final file = File(path);

    final encryptedData = await _encryptionService.encryptData(
      jsonEncode(data),
    );
    await file.writeAsString(encryptedData.base64);
  }

  Future<Map<String, dynamic>> readEncryptedData() async {
    final path = await _getFilePath();
    final file = File(path);

    if (!await file.exists()) {
      return {};
    }

    final encryptedDataBase64 = await file.readAsString();
    final encryptedData = Encrypted(base64Decode(encryptedDataBase64));
    final decryptedData = await _encryptionService.decryptData(encryptedData);

    return jsonDecode(decryptedData);
  }
}
