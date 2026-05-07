import 'package:flutter/material.dart';
import '../../models/hobby_model.dart';
import '../../services/database_service.dart';
import '../../widgets/state_widgets.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();

    return StreamBuilder<List<HobbyModel>>(
      stream: db.getHobbies(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorView(message: snapshot.error.toString());
        if (snapshot.connectionState == ConnectionState.waiting) return const LoadingWidget();

        final favorites = snapshot.data?.where((h) => h.isFavorite).toList() ?? [];

        if (favorites.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.favorite_border, size: 50, color: Colors.white10),
                  SizedBox(height: 10),
                  Text("Belum ada favorit.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true, // Agar bisa masuk ke dalam ScrollView Profile
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final hobby = favorites[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1C21),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(hobby.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                ),
                title: Text(hobby.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(hobby.location, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                  onPressed: () => db.toggleFavorite(hobby.id, true),
                ),
              ),
            );
          },
        );
      },
    );
  }
}