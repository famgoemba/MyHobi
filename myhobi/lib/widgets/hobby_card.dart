import 'package:flutter/material.dart';
import '../models/hobby_model.dart';

class HobbyCard extends StatelessWidget {
  final HobbyModel hobby;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;

  const HobbyCard({
    super.key,
    required this.hobby,
    required this.onDelete,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            hobby.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(hobby.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(hobby.location),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                hobby.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: hobby.isFavorite ? Colors.red : null,
              ),
              onPressed: onFavorite,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}