import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _useBiometrics = false;
  int _lockTimeout = 60;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useBiometrics = prefs.getBool('useBiometrics') ?? false;
      _lockTimeout = prefs.getInt('lockTimeout') ?? 60;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useBiometrics', _useBiometrics);
    await prefs.setInt('lockTimeout', _lockTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Use Biometrics'),
                Switch(
                  value: _useBiometrics,
                  onChanged: (value) {
                    setState(() {
                      _useBiometrics = value;
                    });
                    _savePreferences();
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Lock Timeout (seconds)'),
                Expanded(
                  child: Slider(
                    value: _lockTimeout.toDouble(),
                    min: 10,
                    max: 300,
                    divisions: 29,
                    label: _lockTimeout.toString(),
                    onChanged: (value) {
                      setState(() {
                        _lockTimeout = value.toInt();
                      });
                      _savePreferences();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
