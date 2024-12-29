import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/produk_model.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/services/appwrite_service.dart';

class UpdateProductScreen extends StatefulWidget {
  final ProdukModel product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  XFile? selectedImage;
  bool isLoading = false;
  final AppwriteService _appwriteService = AppwriteService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.nama);
    priceController = TextEditingController(text: widget.product.harga);
    descriptionController =
        TextEditingController(text: widget.product.deskripsi);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  Future<void> _updateProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua bidang harus diisi!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _appwriteService.updateProduct(
        widget.product.id,
        nameController.text,
        priceController.text,
        descriptionController.text,
        imagePath: selectedImage?.path,
        oldImageId: widget.product.gambarId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui produk: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Perbarui Produk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3B5998),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Harga Produk',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Produk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B5998),
                  ),
                  child: const Text(
                    'Pilih Gambar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                if (selectedImage != null)
                  Text(
                    selectedImage!.name,
                    overflow: TextOverflow.ellipsis,
                  )
                else if (widget.product.gambar != null)
                  Image.network(
                    widget.product.gambar!,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
            const SizedBox(height: 32),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B5998),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text(
                        'Perbarui Produk',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
