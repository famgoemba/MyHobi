import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hobby_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream untuk mengambil daftar hobi secara real-time
  Stream<List<HobbyModel>> getHobbies() {
    return _db.collection('hobbies').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => HobbyModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Tambah Hobi Baru
  Future<void> addHobby(HobbyModel hobby) async {
    await _db.collection('hobbies').add(hobby.toMap());
  }

  // Hapus Hobi
  Future<void> deleteHobby(String id) async {
    await _db.collection('hobbies').doc(id).delete();
  }

  // Update Status Favorit
  Future<void> toggleFavorite(String id, bool status) async {
    await _db.collection('hobbies').doc(id).update({'isFavorite': !status});
  }
}