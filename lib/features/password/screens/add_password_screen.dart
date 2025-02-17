import 'package:flutter/material.dart';
import '../../../core/models/password.dart';

class AddPasswordScreen extends StatefulWidget {
  @override
  _AddPasswordScreenState createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _serviceController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _serviceController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final password = Password(
                  service: _serviceController.text,
                  username: _usernameController.text,
                  password: _passwordController.text,
                );
                Navigator.pop(context, password);
              },
              child: Text('Save Password'),
            ),
          ],
        ),
      ),
    );
  }
}
