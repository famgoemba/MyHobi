import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/hobby_model.dart';
import '../../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  int _activeTab = 0;
  final List<String> _tabs = ["Latest", "Trending", "Saved"];

  final List<Map<String, String>> _newsUpdates = [
    {
      "title": "Turnamen Futsal Nasional 2026 Dibuka!",
      "category": "Sports",
      "image": "https://images.unsplash.com/photo-1574629810360-7efbbe195018"
    },
    {
      "title": "Tips Merawat Kamera Analog agar Awet",
      "category": "Photography",
      "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32"
    },
    {
      "title": "Komunitas Diecast Porsche Indonesia Gathering",
      "category": "Hobby",
      "image": "https://images.unsplash.com/photo-1503376780353-7e6692767b70"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Hapus Scaffold & Row Sidebar di sini karena sudah ada di MainWrapper
    return Row(
      children: [
        // AREA TENGAH (FEED)
        Expanded(
          flex: 3,
          child: CustomScrollView(
            slivers: [
              _buildNewsSection(),
              _buildTabSelector(),
              _buildHobbyFeed(user),
            ],
          ),
        ),
        
        // AREA KANAN (FILTER PANEL)
        // Tetap dipertahankan karena ini bagian dari konten spesifik Home
        _buildRightFilterPanel(),
      ],
    );
  }

  // --- KOMPONEN KONTEN ---

  Widget _buildNewsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 16, 15),
            child: Text("Berita Hobi Terkini", 
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: _newsUpdates.length,
              itemBuilder: (context, index) => _newsCard(_newsUpdates[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newsCard(Map<String, String> news) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(news['image']!), 
          fit: BoxFit.cover, 
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
              decoration: BoxDecoration(color: const Color(0xFFC0EB1E), borderRadius: BorderRadius.circular(6)), 
              child: Text(news['category']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black))
            ),
            const SizedBox(height: 8),
            Text(news['title']!, 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_tabs.length, (i) => GestureDetector(
            onTap: () => setState(() => _activeTab = i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: _activeTab == i ? const Color(0xFF1B1C21) : Colors.transparent, 
                borderRadius: BorderRadius.circular(12),
                border: _activeTab == i ? Border.all(color: const Color(0xFFC0EB1E).withOpacity(0.3)) : null,
              ),
              child: Text(_tabs[i], 
                style: TextStyle(color: _activeTab == i ? const Color(0xFFC0EB1E) : Colors.grey, fontWeight: FontWeight.bold)),
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildHobbyFeed(User? user) {
    return StreamBuilder<List<HobbyModel>>(
      stream: _db.getHobbies(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Color(0xFFC0EB1E))));
        
        var hobbies = snapshot.data!;
        if (_activeTab == 2) { 
          hobbies = hobbies.where((h) => h.isFavorite).toList();
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _postCard(hobbies[index], user),
              childCount: hobbies.length,
            ),
          ),
        );
      },
    );
  }

  Widget _postCard(HobbyModel hobby, User? user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1C21), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${user?.email}&background=C0EB1E&color=000'),
            ),
            title: Text(user?.email?.split('@')[0] ?? 'User', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(hobby.location, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            trailing: const Icon(Icons.more_horiz, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Text(hobby.name, style: const TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              hobby.imageUrl, 
              height: 400, 
              width: double.infinity, 
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _actionButton(
                hobby.isFavorite ? Icons.favorite : Icons.favorite_border, 
                hobby.isFavorite ? Colors.red : Colors.grey, 
                "Like",
                () => _db.toggleFavorite(hobby.id, hobby.isFavorite)
              ),
              const SizedBox(width: 25),
              _actionButton(Icons.chat_bubble_outline, Colors.grey, "Comment", () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildRightFilterPanel() {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF1B1C21), 
        border: Border(left: BorderSide(color: Colors.white10))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.tune, color: Color(0xFFC0EB1E), size: 20), 
            SizedBox(width: 10), 
            Text("Filters", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
          ]),
          const SizedBox(height: 30),
          const Text("LOKASI FEED", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF0F1014), borderRadius: BorderRadius.circular(10)),
            child: const Text("Worldwide", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}