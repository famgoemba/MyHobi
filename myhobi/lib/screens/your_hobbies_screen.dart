import 'package:flutter/material.dart';

class YourHobbiesScreen extends StatefulWidget {
  const YourHobbiesScreen({super.key});

  @override
  State<YourHobbiesScreen> createState() => _YourHobbiesScreenState();
}

class _YourHobbiesScreenState extends State<YourHobbiesScreen> {
  String selectedHobby = "Hobbies not selected";

  // Data Hobi Lengkap sesuai kategori di screenshot
  final Map<String, List<String>> hobbyData = {
    "Arts": ["Drawing", "Painting", "Photography", "Sculpting", "Digital Art", "Calligraphy"],
    "Food": ["Cooking", "Baking", "Coffee Brewing", "Wine Tasting", "Food Vlogging", "Pastry"],
    "Games": ["Board Games", "Card Games", "Chess", "Gaming League", "Mini Gaming", "Puzzle Solving"],
    "Learning": ["Language Learning", "Coding", "History", "Science", "Philosophy", "Psychology"],
    "Literature": ["Creative Writing", "Poetry", "Novel Reading", "Journaling", "Book Club", "Scriptwriting"],
    "Music": ["Guitar", "Piano", "DJing", "Singing", "Music Production", "Drumming"],
    "Nature": ["Hiking", "Gardening", "Bird Watching", "Camping", "Stargazing", "Surfing"],
    "Social": ["Volunteering", "Public Speaking", "Networking", "Event Planning", "Board Game Night"],
    "Sports": ["Football", "Basketball", "Tennis", "Swimming", "Gym & Fitness", "Cycling"],
    "Tech": ["3D Modeling", "Robotics", "AR/VR Development", "PC Building", "Cybersecurity"],
  };

  final List<Map<String, dynamic>> categories = [
    {"name": "Arts", "icon": Icons.edit_note, "count": 26},
    {"name": "Food", "icon": Icons.ramen_dining, "count": 10},
    {"name": "Games", "icon": Icons.videogame_asset, "count": 18},
    {"name": "Learning", "icon": Icons.psychology, "count": 17},
    {"name": "Literature", "icon": Icons.menu_book, "count": 10},
    {"name": "Music", "icon": Icons.music_note, "count": 18},
    {"name": "Nature", "icon": Icons.park, "count": 13},
    {"name": "Social", "icon": Icons.groups, "count": 14},
    {"name": "Sports", "icon": Icons.sports_football, "count": 20},
    {"name": "Tech", "icon": Icons.view_in_ar, "count": 15},
  ];

  void _showHobbyDetails(String categoryName, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              Text(categoryName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.black54),
              )
            ],
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mengambil list hobi berdasarkan kategori yang diklik
              ...hobbyData[categoryName]!.map((hobby) => _buildHobbyOption(hobby)).toList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1C21),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHobbyOption(String title) {
    bool isSelected = selectedHobby == title;
    return InkWell(
      onTap: () => setState(() => selectedHobby = title),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8F9FA) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Back to Profile", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B1C21),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context, selectedHobby),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _showHobbyDetails(cat['name'], cat['icon']),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(10)),
                        child: Icon(cat['icon'], color: Colors.black, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cat['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                            const SizedBox(height: 2),
                            Text("Explore ${cat['count']} hobbies", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}