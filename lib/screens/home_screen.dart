import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/produk_model.dart';
import 'package:myapp/screens/add_product_screen.dart';
import 'package:myapp/screens/detail_product.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/services/appwrite_service.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final AppwriteService appwriteService = AppwriteService();
  TextEditingController searchController = TextEditingController();
  List<ProdukModel> allProducts = [];
  List<ProdukModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final products = await appwriteService.fetchProducts();
    setState(() {
      allProducts = products;
      filteredProducts = products;
    });
  }

  void filterProducts(String query) {
    final filtered = allProducts.where((product) {
      final productName = product.nama.toLowerCase();
      final input = query.toLowerCase();
      return productName.contains(input);
    }).toList();

    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B5998),
        title: const Text(
          'OLX',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await appwriteService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5.0),
            Text(
              'Welcome, ${user?.email ?? 'User'}!',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 20.0),

            // Search Field
            TextField(
              controller: searchController,
              onChanged: filterProducts,
              decoration: InputDecoration(
                labelText: 'Cari Produk',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Product List
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('Tidak ada produk tersedia.'))
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  product: product,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 1,
                            color: Colors.white,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  ),
                                  child: product.gambar != null
                                      ? Image.network(
                                          product.gambar!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 100,
                                          width: 100,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.nama,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.harga,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: user!.name == "admin"
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF3B5998),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProductScreen()),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
