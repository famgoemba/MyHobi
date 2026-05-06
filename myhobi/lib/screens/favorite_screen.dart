import 'package:flutter/material.dart';
import '../../models/hobby_model.dart';
import '../../services/database_service.dart';
import '../../widgets/state_widgets.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
      ),
      body: StreamBuilder<List<HobbyModel>>(
        // Mengambil data hobi secara real-time
        stream: db.getHobbies(), 
        builder: (context, snapshot) {
          if (snapshot.hasError) return ErrorView(message: snapshot.error.toString());
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingWidget();

          // Filter hanya yang masuk daftar favorit
          final favorites = snapshot.data?.where((h) => h.isFavorite).toList() ?? [];

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text("Belum ada favorit.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final hobby = favorites[index];

              return Dismissible(
                key: Key(hobby.id),
                direction: DismissDirection.endToStart, // Geser ke kiri untuk hapus
                onDismissed: (direction) {
                  // Hapus dari favorit (set isFavorite jadi false)
                  db.toggleFavorite(hobby.id, true);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${hobby.name} dihapus dari favorit"),
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () => db.toggleFavorite(hobby.id, false),
                      ),
                    ),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.heart_broken, color: Colors.white),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      // FIX: Gunakan Image.network secara universal untuk Web & Mobile
                      child: Image.network(
                        hobby.imageUrl, 
                        width: 60, 
                        height: 60, 
                        fit: BoxFit.cover,
                        // Handler jika gambar gagal dimuat
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(hobby.name, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.blueAccent),
                          const SizedBox(width: 4),
                          Text(hobby.location, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.favorite, color: Colors.redAccent),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}