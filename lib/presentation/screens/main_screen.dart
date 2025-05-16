import 'package:flutter/material.dart';

import '../../core/session/session_manager.dart';
import 'home/home_screen.dart';
import 'lock/lock_screen.dart';
import 'operation/operation_screen.dart';
import 'settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Create a navigator key for each tab to maintain separate navigation stacks
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    SessionManager().startTimer(onTimeout: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LockScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SessionManager().resetTimer(),
      child: WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildNavigator(0, HomeScreen()),
              _buildNavigator(1, OperationsScreen()),
              _buildNavigator(2, SettingsScreen()),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.swap_horiz), label: "Opérations"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Réglages"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => child,
        );
      },
    );
  }
}
