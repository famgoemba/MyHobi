import 'package:flutter/material.dart';
import '../../models/hobby_model.dart';
import '../../services/database_service.dart';
import '../../widgets/hobby_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();

    return Scaffold(
      appBar: AppBar(title: const Text("Hobi Favorit")),
      body: StreamBuilder<List<HobbyModel>>(
        stream: db.getHobbies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Filter data hobi yang isFavorite == true
          final favorites = snapshot.data?.where((h) => h.isFavorite).toList() ?? [];

          if (favorites.isEmpty) {
            return const Center(child: Text("Belum ada hobi favorit."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final hobby = favorites[index];
              return HobbyCard(
                hobby: hobby,
                onDelete: () => db.deleteHobby(hobby.id),
                onFavorite: () => db.toggleFavorite(hobby.id, hobby.isFavorite),
              );
            },
          );
        },
      ),
    );
  }
}