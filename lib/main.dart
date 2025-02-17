import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks
import 'core/services/password_service.dart';
import 'features/password/screens/password_list_screen.dart';
import 'features/password/screens/generate_password_screen.dart'; // Import GeneratePasswordScreen
import 'features/password/screens/settings_screen.dart'; // Import SettingsScreen
import 'features/password/screens/fill_password_screen.dart'; // Import FillPasswordScreen
import 'features/password/screens/send_password_screen.dart'; // Import SendPasswordScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final passwordService = PasswordService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisperr Pass',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: MainScreen(passwordService: passwordService), // Use MainScreen
    );
  }
}

class MainScreen extends HookWidget {
  final PasswordService passwordService;

  const MainScreen({Key? key, required this.passwordService}) : super(key: key);

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
