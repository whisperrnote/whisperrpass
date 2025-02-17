import 'package:flutter/material.dart';
import '../../../core/models/password.dart';

class PasswordListItem extends StatelessWidget {
  final Password password;
  final VoidCallback onDelete;

  const PasswordListItem({
    super.key,
    required this.password,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(password.service),
      subtitle: Text(password.username),
      trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
    );
  }
}
