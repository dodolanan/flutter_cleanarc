import 'package:flutter/material.dart';
import 'package:myapp/models/produk_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProdukModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          product.nama,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3B5998),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Product Image
            if (product.gambar != null)
              Center(
                child: Image.network(
                  product.gambar!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            const SizedBox(height: 16),
            // Product Name
            Text(
              product.nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Product Price
            Text(
              'Rp ${product.harga}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // Product Description
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.deskripsi,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
