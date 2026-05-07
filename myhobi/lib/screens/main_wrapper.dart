import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'games_screen.dart';
import 'profile_screen.dart';
import 'add_hobby_screen.dart'; // Import halaman tambah hobi

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatScreen(),
    const GamesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1014),
      
      // --- TOMBOL TAMBAH HOBI (FAB) ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC0EB1E),
        elevation: 4,
        onPressed: () {
          // Navigasi ke halaman tambah hobi yang baru kita buat
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHobbyScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),

      // --- LAYOUT UTAMA ---
      body: Row(
        children: [
          // Sidebar Kiri Tetap (Fixed)
          _buildSidebar(),
          
          // Konten Utama yang berganti-ganti
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

  // --- WIDGET SIDEBAR ---
  Widget _buildSidebar() {
    return Container(
      width: 70,
      decoration: const BoxDecoration(
        color: Color(0xFF1B1C21),
        border: Border(right: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo singkat MyHobi (Opsional)
          const Text("MH", style: TextStyle(color: Color(0xFFC0EB1E), fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 40),
          
          _sidebarItem(Icons.home_filled, 0),
          _sidebarItem(Icons.chat_bubble_outline, 1),
          _sidebarItem(Icons.videogame_asset_outlined, 2),
          _sidebarItem(Icons.person_outline, 3),
          
          const Spacer(),
          
          // Tombol Setting di bawah
          _sidebarItem(Icons.settings, 99), // 99 hanya dummy index
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index != 99) {
          setState(() => _selectedIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFC0EB1E).withOpacity(0.05) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFFC0EB1E) : Colors.grey,
          size: 26,
        ),
      ),
    );
  }
}