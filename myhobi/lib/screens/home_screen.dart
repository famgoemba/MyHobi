import 'dart:io'; // Penting untuk menangani file gambar lokal
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan ini
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
  
  File? _imageFile; // Variabel untuk menyimpan gambar yang dipilih
  final ImagePicker _picker = ImagePicker();

  String get _displayName => user?.email?.split('@')[0] ?? 'User';

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> _pickImage(StateSetter setDialogState) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setDialogState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showAddHobbyDialog() {
    // Reset image setiap kali dialog dibuka
    _imageFile = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // Agar UI di dalam dialog bisa update saat pilih gambar
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Tambah Hobi Baru", style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- BAGIAN PILIH GAMBAR ---
                  GestureDetector(
                    onTap: () => _pickImage(setDialogState),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, color: Colors.blueAccent),
                                SizedBox(height: 8),
                                Text("Pilih Gambar", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // --- INPUT NAMA ---
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Nama Hobi",
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // --- INPUT LOKASI ---
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: "Lokasi Spesifik",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  if (_nameController.text.isNotEmpty) {
                    // Simpan data (Path gambar lokal disimpan ke imageUrl)
                    await _db.addHobby(HobbyModel(
                      id: '',
                      name: _nameController.text,
                      location: _locationController.text,
                      imageUrl: _imageFile?.path ?? 'https://picsum.photos/seed/hobi/400',
                      isFavorite: false,
                    ));
                    _nameController.clear();
                    _locationController.clear();
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (Sisa build sama seperti kodingan estetik sebelumnya)
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Header & Greeting
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Halo, $_displayName! 👋",
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Kelola koleksi hobimu hari ini.",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: const Icon(Icons.notifications_none_rounded, color: Colors.blueAccent),
                    )
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.blueAccent.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("Total Hobi", total.toString(), Colors.white),
                          Container(height: 40, width: 1, color: Colors.white24),
                          _buildStatItem("Favorit", favorites.toString(), Colors.white),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Text("Koleksi Kamu", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            // 3. List Hobi (Real-time)
            StreamBuilder<List<HobbyModel>>(
              stream: _db.getHobbies(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return SliverToBoxAdapter(child: ErrorView(message: snapshot.error.toString()));
                if (snapshot.connectionState == ConnectionState.waiting) return const SliverToBoxAdapter(child: LoadingWidget());
                
                final hobbies = snapshot.data ?? [];
                if (hobbies.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text("Belum ada koleksi hobi.", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HobbyCard(
                          hobby: hobbies[index],
                          onDelete: () => _db.deleteHobby(hobbies[index].id),
                          onFavorite: () => _db.toggleFavorite(hobbies[index].id, hobbies[index].isFavorite),
                        ),
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
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        label: const Text("Hobi Baru", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 13, color: color.withOpacity(0.8))),
      ],
    );
  }
}