import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Data simulasi chat sesuai gaya MyHobi
  final List<Map<String, String>> _recentChats = [
    {
      "name": "Febby Lestari",
      "msg": "Amazing fine art! Kapan pamerannya?",
      "time": "4:48 AM",
      "image": "https://i.pravatar.cc/150?u=alina"
    },
    {
      "name": "Joy Syukur Dohona",
      "msg": "Great knock! Truly deserved a hundred.",
      "time": "Yesterday",
      "image": "https://i.pravatar.cc/150?u=hamza"
    },
    {
      "name": "M Junaidi",
      "msg": "RGB Neon-nya mantap bener, Bos!",
      "time": "2 hours ago",
      "image": "https://i.pravatar.cc/150?u=pro"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Kita hapus Scaffold & Row Sidebar karena sudah dihandle oleh MainWrapper
    return Row(
      children: [
        // --- DAFTAR CHAT (INBOX) ---
        Container(
          width: 350,
          decoration: const BoxDecoration(
            color: Color(0xFF1B1C21),
            border: Border(right: BorderSide(color: Colors.white10)),
          ),
          child: Column(
            children: [
              _buildChatHeader(),
              _buildSearchChat(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _recentChats.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                  itemBuilder: (context, index) => _buildChatItem(_recentChats[index]),
                ),
              ),
            ],
          ),
        ),

        // --- AREA DETAIL CHAT (PLACEHOLDER) ---
        Expanded(
          child: Container(
            color: const Color(0xFF0F1014),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon placeholder dengan warna Neon Hijau tipis
                  Icon(Icons.forum_outlined, size: 100, color: const Color(0xFFC0EB1E).withOpacity(0.05)),
                  const SizedBox(height: 20),
                  const Text(
                    "Pilih obrolan untuk mulai diskusi hobi", 
                    style: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 0.5)
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- KOMPONEN WIDGET ---

  Widget _buildChatHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
      child: Row(
        children: [
          const Text(
            "Messages", 
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFC0EB1E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.edit_square, color: Color(0xFFC0EB1E), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChat() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1014),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: "Search direct messages...",
          hintStyle: TextStyle(color: Colors.grey),
          icon: Icon(Icons.search, color: Colors.grey, size: 18),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildChatItem(Map<String, String> chat) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(chat['image']!),
            backgroundColor: Colors.grey[800],
          ),
          // Indikator Online (Opsional, buat pemanis)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFFC0EB1E),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1B1C21), width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            chat['name']!, 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)
          ),
          Text(
            chat['time']!, 
            style: const TextStyle(color: Colors.grey, fontSize: 10)
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          chat['msg']!, 
          style: const TextStyle(color: Colors.grey, fontSize: 13), 
          maxLines: 1, 
          overflow: TextOverflow.ellipsis
        ),
      ),
      onTap: () {
        // Implementasi buka chat detail
      },
    );
  }
}