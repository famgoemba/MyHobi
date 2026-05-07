import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import 'sign_in_screen.dart';
import 'your_hobbies_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _bioController = TextEditingController();
  
  // Data dummy untuk hobi, nanti bisa diupdate dari YourHobbiesScreen
  String selectedCategory = "Games";
  List<String> mySubHobbies = ["Card Games"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F1014),
      padding: const EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- KOLOM KIRI: INFO PROFIL ---
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 20),
                  _buildAccountDetails(),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 30),

          // --- KOLOM KANAN: HOBBIES ---
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Section: Your Hobbies (Statik/Placeholder)
                _buildHobbySection(
                  title: "Your Hobbies",
                  category: "Hobbies not selected",
                  subHobbies: [],
                  categoryIcon: Icons.help_outline,
                ),
                
                const SizedBox(height: 20),
                
                // Section: Hobbies to Swap (Bisa di-expand)
                _buildHobbySection(
                  title: "Hobbies to Swap",
                  category: selectedCategory,
                  subHobbies: mySubHobbies,
                  categoryIcon: Icons.videogame_asset,
                  isExpandable: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET KOMPONEN ---

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1C21),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Saved!")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F1014),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFFC0EB1E),
                child: CircleAvatar(
                  radius: 33,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1503376780353-7e6692767b70'),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.displayName ?? "Daffa Aqilahsyah", 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(user?.email ?? "daffa@student.com", 
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _bioController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              hintText: "Tell us a little about yourself...",
              hintStyle: TextStyle(color: Colors.white24),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white10, height: 30),
          _buildSettingsTile(Icons.language, "App Language", "English"),
        ],
      ),
    );
  }

  Widget _buildAccountDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1C21),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoField(Icons.person_outline, user?.displayName ?? "Daffa Aqilahsyah"),
          _buildInfoField(Icons.fingerprint, user?.uid ?? "ID-2327240085"),
          _buildInfoField(Icons.email_outlined, user?.email ?? "daffa@student.com"),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              await AuthService().signOut();
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen()));
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHobbySection({
    required String title, 
    required String category, 
    required List<String> subHobbies, 
    required IconData categoryIcon,
    bool isExpandable = false
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1C21),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white54, size: 20),
                onPressed: () async {
                  final result = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const YourHobbiesScreen())
                  );
                  if (result != null) {
                    setState(() {
                      selectedCategory = "Custom"; // Logika update data hobi kamu
                      mySubHobbies = [result];
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F1014),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isExpandable 
                ? ExpansionTile(
                    leading: Icon(categoryIcon, color: Colors.white, size: 22),
                    title: Text(category, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                    childrenPadding: const EdgeInsets.only(left: 55, bottom: 15),
                    expandedAlignment: Alignment.centerLeft,
                    children: subHobbies.map((h) => Text(h, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.8))).toList(),
                  )
                : ListTile(
                    leading: Icon(categoryIcon, color: Colors.white54, size: 22),
                    title: Text(category, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String trailing) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFC0EB1E), size: 20),
        const SizedBox(width: 15),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const Spacer(),
        Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
      ],
    );
  }

  Widget _buildInfoField(IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1014),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 18),
          const SizedBox(width: 15),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}