import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _passwordController = TextEditingController();
  bool _useBiometrics = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useBiometrics = prefs.getBool('useBiometrics') ?? false;
    });
    if (_useBiometrics) {
      _authenticateWithBiometrics();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to unlock WhisperrPass',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        _unlockApp();
      }
    } catch (e) {
      print("Error authenticating with biometrics: $e");
      // Fallback to password
    }
  }

  void _unlockApp() {
    // Navigate to the main screen
    Navigator.pushReplacementNamed(
      context,
      '/password_list',
    ); // Replace with your main screen route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('WhisperrPass Locked'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate password (replace with your actual validation logic)
                if (_passwordController.text == 'your_password') {
                  _unlockApp();
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect password')),
                  );
                }
              },
              child: const Text('Unlock'),
            ),
            if (_useBiometrics)
              TextButton(
                onPressed: _authenticateWithBiometrics,
                child: const Text('Authenticate with Biometrics'),
              ),
          ],
        ),
      ),
    );
  }
}
