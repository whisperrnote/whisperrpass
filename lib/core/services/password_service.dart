import '../models/password.dart';

class PasswordService {
  final List<Password> _passwords = [];

  List<Password> get passwords => _passwords;

  void addPassword(Password password) {
    _passwords.add(password);
  }

  void deletePassword(int index) {
    _passwords.removeAt(index);
  }
}
