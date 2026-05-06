import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/hobby_model.dart';
import '../../services/database_service.dart';
import '../../widgets/hobby_card.dart';
import '../../widgets/state_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void _showAddHobbyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Hobi Baru"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Hobi")),
            TextField(controller: _locationController, decoration: const InputDecoration(labelText: "Lokasi")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty) {
                await _db.addHobby(HobbyModel(
                  id: '',
                  name: _nameController.text,
                  location: _locationController.text,
                  imageUrl: 'https://picsum.photos/seed/${_nameController.text}/200',
                ));
                _nameController.clear();
                _locationController.clear();
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. Header & Greeting
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Halo, ${user?.email?.split('@')[0] ?? 'User'}! 👋",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text("Kelola hobimu agar tetap produktif.",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            // 2. Stats Card Section
            SliverToBoxAdapter(
              child: StreamBuilder<List<HobbyModel>>(
                stream: _db.getHobbies(),
                builder: (context, snapshot) {
                  int total = snapshot.data?.length ?? 0;
                  int favorites = snapshot.data?.where((h) => h.isFavorite).length ?? 0;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("Total Hobi", total.toString()),
                          const VerticalDivider(color: Colors.white24),
                          _buildStatItem("Favorit", favorites.toString()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // 3. List Hobi (Real-time)
            StreamBuilder<List<HobbyModel>>(
              stream: _db.getHobbies(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return SliverToBoxAdapter(child: ErrorView(message: snapshot.error.toString()));
                if (snapshot.connectionState == ConnectionState.waiting) return const SliverToBoxAdapter(child: LoadingWidget());
                
                final hobbies = snapshot.data ?? [];
                if (hobbies.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("Belum ada koleksi hobi.")),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => HobbyCard(
                        hobby: hobbies[index],
                        onDelete: () => _db.deleteHobby(hobbies[index].id),
                        onFavorite: () => _db.toggleFavorite(hobbies[index].id, hobbies[index].isFavorite),
                      ),
                      childCount: hobbies.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddHobbyDialog,
        label: const Text("Hobi Baru"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}