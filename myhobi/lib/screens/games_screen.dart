import 'package:flutter/material.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  // Daftar hobi/game yang bisa dipilih (multi-select)
  final List<Map<String, dynamic>> _gameCategories = [
    {"name": "Futsal", "icon": Icons.sports_soccer, "selected": false},
    {"name": "Photography", "icon": Icons.camera_alt, "selected": false},
    {"name": "Diecast", "icon": Icons.directions_car, "selected": false},
    {"name": "E-Sports", "icon": Icons.videogame_asset, "selected": false},
    {"name": "Analog", "icon": Icons.camera_roll, "selected": false},
    {"name": "Basketball", "icon": Icons.sports_basketball, "selected": false},
    {"name": "Music", "icon": Icons.music_note, "selected": false},
    {"name": "PC Building", "icon": Icons.settings_input_component, "selected": false},
  ];

  @override
  Widget build(BuildContext context) {
    // Kita langsung return kontainer utama tanpa Scaffold/Sidebar
    return Container(
      color: const Color(0xFF0F1014),
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Text(
            "Select Your Hobbies",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 28, 
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Personalisasi feed kamu. Pilih komunitas hobi yang ingin kamu ikuti.",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 40),

          // Grid Hobi
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 Kolom untuk tampilan dashboard luas
                childAspectRatio: 1.4,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
              ),
              itemCount: _gameCategories.length,
              itemBuilder: (context, index) => _buildGameCard(index),
            ),
          ),

          // Footer Actions
          _buildFooterActions(),
        ],
      ),
    );
  }

  Widget _buildGameCard(int index) {
    bool isSelected = _gameCategories[index]['selected'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _gameCategories[index]['selected'] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC0EB1E).withOpacity(0.08) : const Color(0xFF1B1C21),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFC0EB1E) : Colors.white.withOpacity(0.05),
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFFC0EB1E).withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFC0EB1E) : Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _gameCategories[index]['icon'],
                color: isSelected ? Colors.black : Colors.white70,
                size: 28,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              _gameCategories[index]['name'],
              style: TextStyle(
                color: isSelected ? const Color(0xFFC0EB1E) : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tombol Reset
          TextButton.icon(
            onPressed: () => setState(() {
              for (var item in _gameCategories) { item['selected'] = false; }
            }),
            icon: const Icon(Icons.refresh, color: Colors.grey, size: 18),
            label: const Text("Reset Selection", style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 25),
          
          // Tombol Save
          ElevatedButton(
            onPressed: () {
              // Logika simpan pilihan ke Firebase Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Hobi kamu telah diperbarui!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC0EB1E),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              "SAVE CHOICES", 
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }
}