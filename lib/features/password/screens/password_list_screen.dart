import 'package:flutter/material.dart';
import '../../../core/models/password.dart';
import '../../../core/services/password_service.dart';
import '../widgets/password_list_item.dart';
import 'add_password_screen.dart';

class PasswordListScreen extends StatefulWidget {
  final PasswordService passwordService;

  const PasswordListScreen({super.key, required this.passwordService});

  @override
  _PasswordListScreenState createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  String _searchQuery = '';

  List<Password> get _filteredPasswords {
    if (_searchQuery.isEmpty) {
      return widget.passwordService.passwords;
    } else {
      return widget.passwordService.passwords
          .where(
            (password) =>
                password.service.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                password.username.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Passwords'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search Passwords',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPasswords.length,
              itemBuilder: (context, index) {
                return PasswordListItem(
                  password: _filteredPasswords[index],
                  onDelete:
                      () => setState(() {
                        widget.passwordService.deletePassword(index);
                      }),
                );
              },
            ),
          ),
          // Password Category Region (Example)
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text('Password Categories Go Here'),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPasswordScreen()),
            );
            if (result != null) {
              setState(() {
                widget.passwordService.addPassword(result);
              });
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
