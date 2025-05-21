import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/views/home/home_screen.dart';
import 'package:communication_practice/views/history/conversation_history_screen.dart';
import 'package:communication_practice/views/profile/profile_screen.dart';
import 'package:communication_practice/views/settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const ConversationHistoryScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];
  
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }
  
  Future<void> _checkAuthentication() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    if (!authController.isAuthenticated) {
      // Handle not authenticated state
    }
  }
  
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? AppColors.surface
                : AppColors.darkSurface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Theme.of(context).brightness == Brightness.light
                ? AppColors.textSecondary
                : AppColors.darkTextSecondary,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history_rounded),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}