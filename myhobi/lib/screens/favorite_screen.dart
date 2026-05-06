import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 3, // Contoh jumlah data favorit
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://images.unsplash.com/photo-1555680202-c86f0e12f086", // Contoh item hobi
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text("Kamera Analog Canon", 
                style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Koleksi Fotografi"),
              trailing: const Icon(Icons.favorite, color: Colors.redAccent),
            ),
          );
        },
      ),
    );
  }
}