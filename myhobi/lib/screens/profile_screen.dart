import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../providers/theme_provider.dart';
import 'sign_in_screen.dart';
import 'favorite_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile(String currentName) async {
    if (user == null) return;
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _nameController.text.trim(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pop(context); // Tutup Loading
        Navigator.pop(context); // Tutup Dialog Edit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!")),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("Error Update Profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      // Background mengikuti tema
      backgroundColor: isDark ? const Color(0xFF0F1014) : const Color(0xFFF5F5F5),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          final String name = userData?['name'] ?? user?.displayName ?? 'User';
          final String email = userData?['email'] ?? user?.email ?? '';
          final String? photoUrl = userData?['photoUrl'];

          return CustomScrollView(
            slivers: [
              // Header dengan Gambar Mobil Sport & Info User
              _buildSliverHeader(name, email, photoUrl),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("PENGATURAN & TEMA", isDark),
                      const SizedBox(height: 15),
                      
                      // Card Switch Mode Gelap
                      _buildMenuCard(
                        isDark,
                        icon: Icons.palette_outlined,
                        title: "Mode Gelap",
                        subtitle: isDark ? "Tema Gelap Aktif" : "Tema Terang Aktif",
                        trailing: Switch(
                          value: isDark,
                          onChanged: (value) => themeProvider.toggleTheme(),
                          activeColor: const Color(0xFFC0EB1E),
                        ),
                      ),

                      // Card Edit Profil
                      GestureDetector(
                        onTap: () => _showEditProfileDialog(name),
                        child: _buildMenuCard(
                          isDark,
                          icon: Icons.person_outline,
                          title: "Edit Profil",
                          subtitle: "Ubah nama tampilan akunmu",
                        ),
                      ),

                      const SizedBox(height: 40),
                      _buildSectionTitle("FAVORIT SAYA", isDark),
                      const SizedBox(height: 15),
                      
                      // Menampilkan FavoriteView secara menyatu di sini
                      const FavoriteView(), 

                      const SizedBox(height: 50),
                      _buildLogoutButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSliverHeader(String name, String email, String? photoUrl) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF1B1C21),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image Sport Car
            Image.network(
              'https://images.unsplash.com/photo-1503376780353-7e6692767b70', 
              fit: BoxFit.cover
            ),
            Container(color: Colors.black.withOpacity(0.5)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFC0EB1E),
                  child: CircleAvatar(
                    radius: 47,
                    backgroundImage: NetworkImage(
                      photoUrl ?? 'https://ui-avatars.com/api/?name=$name&background=1B1C21&color=C0EB1E'
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(email, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? const Color(0xFFC0EB1E) : Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildMenuCard(bool isDark, {required IconData icon, required String title, required String subtitle, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1C21) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Icon(icon, color: const Color(0xFFC0EB1E)),
        title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () async {
          await AuthService().signOut();
          if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SignInScreen()), (r) => false);
        },
        icon: const Icon(Icons.logout, color: Colors.redAccent),
        label: const Text("Keluar dari Akun", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showEditProfileDialog(String currentName) {
    _nameController.text = currentName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B1C21),
        title: const Text("Ubah Nama", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Masukkan nama baru...",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC0EB1E)),
            onPressed: () => _updateProfile(currentName),
            child: const Text("Simpan", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}