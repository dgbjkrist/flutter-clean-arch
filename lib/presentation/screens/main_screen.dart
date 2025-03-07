import 'package:flutter/material.dart';

import '../../core/session/session_manager.dart';
import 'home/home_screen.dart';
import 'lock_screen.dart';
import 'operation/operation_screen.dart';
import 'settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    OperationsScreen(),
    SettingsScreen(),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SessionManager().resetTimer(),
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.swap_horiz), label: "Opérations"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Réglages"),
          ],
        ),
      ),
    );
  }
}
