import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'games_screen.dart';
import 'profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  // Kita tetap menggunakan index untuk menentukan layar mana yang aktif
  int _selectedIndex = 0;

  // List Screen sesuai urutan di Sidebar: Home (0), Chat (1), Games (2), Profile (3)
  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatScreen(),
    const GamesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hapus bottomNavigationBar total
      body: Row(
        children: [
          // Sidebar Navigasi Custom sebagai pengganti BottomNav
          _buildSidebar(),
          
          // Area Konten Utama
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 70,
      color: const Color(0xFF1B1C21), // Warna gelap sesuai desain
      child: Column(
        children: [
          const SizedBox(height: 30),
          _sidebarItem(Icons.home_filled, 0),
          _sidebarItem(Icons.chat_bubble_outline, 1),
          _sidebarItem(Icons.videogame_asset_outlined, 2),
          _sidebarItem(Icons.person_outline, 3),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Icon(Icons.settings, color: Colors.grey, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFFC0EB1E) : Colors.grey,
          size: 26,
        ),
      ),
    );
  }
}