class HobbyModel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final bool isFavorite;

  HobbyModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Mengonversi Map dari Firestore ke Object
  factory HobbyModel.fromMap(Map<String, dynamic> data, String documentId) {
    return HobbyModel(
      id: documentId,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  // Mengonversi Object ke Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}