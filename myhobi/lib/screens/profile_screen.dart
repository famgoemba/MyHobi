import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../providers/theme_provider.dart';
import 'sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final AuthService auth = AuthService();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          final String name = userData?['name'] ?? 'User';
          final String email = userData?['email'] ?? user?.email ?? '';

          return CustomScrollView(
            slivers: [
              // Header dengan Foto Background Cinematic
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1503376780353-7e6692767b70', // Porsche 911 Style
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withOpacity(0.5)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=$name&background=0D8ABC&color=fff'),
                          ),
                          const SizedBox(height: 10),
                          Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(email, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pengaturan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                      const SizedBox(height: 15),

                      // TOMBOL TEMA DI SINI
                      _buildMenuTile(
                        icon: Icons.dark_mode_outlined,
                        title: "Mode Gelap",
                        subtitle: "Atur kenyamanan visual",
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) => themeProvider.toggleTheme(),
                          activeColor: Colors.blueAccent,
                        ),
                      ),

                      _buildMenuTile(
                        icon: Icons.person_outline,
                        title: "Edit Profil",
                        subtitle: "Ubah nama dan info akun",
                      ),

                      const SizedBox(height: 20),
                      // Logout Button
                      ListTile(
                        onTap: () async {
                          await auth.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SignInScreen()), (r) => false);
                          }
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        tileColor: Colors.redAccent.withOpacity(0.1),
                        leading: const Icon(Icons.logout, color: Colors.redAccent),
                        title: const Text("Keluar", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ),
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

  Widget _buildMenuTile({required IconData icon, required String title, required String subtitle, Widget? trailing}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}