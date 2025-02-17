import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/password_service.dart';
import 'features/password/screens/password_list_screen.dart';
import 'features/password/screens/generate_password_screen.dart';
import 'features/password/screens/settings_screen.dart';
import 'features/password/screens/fill_password_screen.dart';
import 'features/password/screens/send_password_screen.dart';
import 'features/lock/lock_screen.dart'; // Import LockScreen
import 'core/services/data_storage_service.dart'; // Import DataStorageService

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisperr Pass',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: AppLifecycleManager(), // Use AppLifecycleManager
      routes: {
        '/lock': (context) => LockScreen(), // Define lock screen route
        '/password_list': (context) => MainScreen(), // Define main screen route
      },
    );
  }
}

class AppLifecycleManager extends StatefulWidget {
  const AppLifecycleManager({super.key});

  @override
  _AppLifecycleManagerState createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver {
  final passwordService = PasswordService();
  final dataStorageService = DataStorageService();
  Timer? _lockTimer;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
    _startLockTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lockTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Check if data file exists
    bool dataExists = await dataStorageService.dataFileExists();

    if (!dataExists) {
      // Initialize default data or show onboarding screen
      if (kDebugMode) {
        print("Data file does not exist. Initializing...");
      }
      // You might want to navigate to an onboarding screen here
    } else {
      // Load data from file
      final data = await dataStorageService.readEncryptedData();
      // Populate passwordService with loaded data
      if (kDebugMode) {
        print("Data loaded: $data");
      }
    }
  }

  Future<void> _saveData() async {
    // Prepare data to be saved (e.g., from passwordService)
    final data = <String, dynamic>{
      // 'passwords': passwordService.passwords.map((p) => p.toJson()).toList(),
    };
    await dataStorageService.writeEncryptedData(data);
  }

  Future<void> _loadLockTimeout() async {
    final prefs = await SharedPreferences.getInstance();
    int timeout = prefs.getInt('lockTimeout') ?? 60; // Default to 60 seconds
    _startLockTimer(timeout: timeout);
  }

  void _startLockTimer({int timeout = 60}) {
    _lockTimer?.cancel();
    _lockTimer = Timer(Duration(seconds: timeout), () {
      _lockApp();
    });
  }

  void _resetLockTimer() {
    _loadLockTimeout();
  }

  void _lockApp() {
    setState(() {
      _isLocked = true;
    });
    Navigator.pushReplacementNamed(context, '/lock');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _startLockTimer();
    } else if (state == AppLifecycleState.resumed) {
      _resetLockTimer();
      if (_isLocked) {
        Navigator.pushReplacementNamed(context, '/lock');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLocked ? LockScreen() : MainScreen();
  }
}

class MainScreen extends HookWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    final screens = [
      PasswordListScreen(passwordService: passwordService),
      FillPasswordScreen(),
      GeneratePasswordScreen(),
      SendPasswordScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 600)
            NavigationRail(
              selectedIndex: selectedIndex.value,
              onDestinationSelected: (index) {
                selectedIndex.value = index;
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.input),
                  label: Text('Fill'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.security),
                  label: Text('Generate'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.send),
                  label: Text('Send'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          Expanded(child: screens[selectedIndex.value]),
        ],
      ),
      bottomNavigationBar:
          MediaQuery.of(context).size.width < 600
              ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex.value,
                onTap: (index) {
                  selectedIndex.value = index;
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.input),
                    label: 'Fill',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.security),
                    label: 'Generate',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.send),
                    label: 'Send',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              )
              : null,
    );
  }
}
