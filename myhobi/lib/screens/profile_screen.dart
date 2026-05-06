import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../providers/theme_provider.dart';
import 'sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Fungsi Inti Penyimpanan
  Future<void> _updateProfile(String currentName, String? currentPhoto) async {
    if (user == null) return;

    try {
      // Tampilkan Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final String newName = _nameController.text.trim();
      final String photoToSave = _imageFile?.path ?? currentPhoto ?? '';

      // Gunakan set(merge: true) agar data tetap masuk meskipun dokumen belum ada
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'name': newName,
        'email': user!.email,
        'photoUrl': photoToSave,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
    }
  }

  void _showEditProfileDialog(String currentName, String? currentPhoto) {
    _nameController.text = currentName;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setDialogState(() => _imageFile = File(picked.path));
                      setState(() => _imageFile = File(picked.path));
                    }
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    backgroundImage: _imageFile != null 
                        ? FileImage(_imageFile!) 
                        : (currentPhoto != null && currentPhoto.isNotEmpty && !currentPhoto.startsWith('http') 
                            ? FileImage(File(currentPhoto)) as ImageProvider 
                            : null),
                    child: (_imageFile == null && (currentPhoto == null || currentPhoto.isEmpty))
                        ? const Icon(Icons.camera_alt_outlined, color: Colors.blueAccent)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () => _updateProfile(currentName, currentPhoto),
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          final String name = userData?['name'] ?? user?.displayName ?? 'User';
          final String email = userData?['email'] ?? user?.email ?? '';
          final String? photoUrl = userData?['photoUrl'];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withOpacity(0.5)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: photoUrl != null && photoUrl.isNotEmpty && !photoUrl.startsWith('http')
                                ? FileImage(File(photoUrl)) as ImageProvider
                                : NetworkImage('https://ui-avatars.com/api/?name=$name&background=0D8ABC&color=fff'),
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
                      GestureDetector(
                        onTap: () => _showEditProfileDialog(name, photoUrl),
                        child: _buildMenuTile(
                          icon: Icons.person_outline,
                          title: "Edit Profil",
                          subtitle: "Ubah nama dan foto profil",
                        ),
                      ),
                      const SizedBox(height: 20),
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