import 'dart:typed_data'; // Penting untuk Web
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/hobby_model.dart';
import '../../services/database_service.dart';

class AddHobbyScreen extends StatefulWidget {
  const AddHobbyScreen({super.key});

  @override
  State<AddHobbyScreen> createState() => _AddHobbyScreenState();
}

class _AddHobbyScreenState extends State<AddHobbyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  
  Uint8List? _selectedImageBytes; // Gunakan bytes agar aman di Web & Mobile
  final _picker = ImagePicker();
  final _db = DatabaseService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // FUNGSI AMBIL GAMBAR DARI GALERI
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pilih foto hobi dulu!")),
        );
        return;
      }

      setState(() => _isLoading = true);
      
      try {
        // Logika: Idealnya upload bytes ke Firebase Storage
        // Untuk sekarang, kita buat model hobi baru
        final newHobby = HobbyModel(
          id: '', 
          name: _nameController.text.trim(),
          location: _locationController.text.trim(),
          imageUrl: "image_stored_as_bytes", // Placeholder
          isFavorite: false,
        );

        await _db.addHobby(newHobby);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hobi berhasil diposting!")),
          );
        }
      } catch (e) {
        debugPrint("Error: $e");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1014),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1C21),
        elevation: 0,
        title: const Text("Create New Post", style: TextStyle(color: Colors.white, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: 500,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1C21),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- PICKER GAMBAR ---
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F1014),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: _selectedImageBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add_a_photo_outlined, color: Color(0xFFC0EB1E), size: 40),
                                SizedBox(height: 12),
                                Text("Select from Gallery", style: TextStyle(color: Colors.grey, fontSize: 13)),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  _buildLabel("Hobby Name"),
                  _buildTextField(_nameController, "e.g. Porsche 911 Restoration", Icons.directions_car),
                  
                  const SizedBox(height: 20),
                  _buildLabel("Location"),
                  _buildTextField(_locationController, "e.g. Jakarta, Indonesia", Icons.location_on),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC0EB1E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text("POST NOW", 
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFFC0EB1E), size: 20),
        filled: true,
        fillColor: const Color(0xFF0F1014),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
    );
  }
}