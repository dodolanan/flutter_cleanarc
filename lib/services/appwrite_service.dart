import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:myapp/models/produk_model.dart';

class AppwriteService {
  late Client _client;
  late Account _account;
  late Databases databases;
  late Storage storage;
  AppwriteService() {
    _client = Client()
      ..setEndpoint('https://cloud.appwrite.io/v1')
      ..setProject('677123c00011701cff06')
      ..setSelfSigned(status: true);
    _account = Account(_client);
    databases = Databases(_client);
    storage = Storage(_client);
  }

  Future<models.User> login(String email, String password) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final user = await _account.get();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<models.User> register(
      String name, String email, String password) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        name: name,
        email: email,
        password: password,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      
    } catch (e) {
      rethrow;
    }
  }

  Future<models.User> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (e) {
      rethrow;
    }
  }

  // Mengambil produk dari database
  Future<List<ProdukModel>> fetchProducts() async {
    try {
      final response = await databases.listDocuments(
        databaseId: '677124420023ea7d08c5',
        collectionId: '67712a3e0011f31510f8',
        queries: [
          Query.orderDesc(
              '\$createdAt'), // Mengurutkan berdasarkan createdAt secara descending
        ],
      );
      return response.documents
          .map((doc) => ProdukModel.fromMap(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      print("Error fetching products: \${e.message}");
      return [];
    } catch (e) {
      print("Unexpected error: \$e");
      return [];
    }
  }

// Menambahkan produk baru dengan gambar
  Future<void> createProduct(String nama, String harga, String deskripsi,
      {String? imagePath}) async {
    try {
      String? imageUrl;
      String? imageId;

      if (imagePath != null) {
        final responseImg = await storage.createFile(
          bucketId: '67712a26002919139bf8', // Ganti dengan bucket ID Anda
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: imagePath,
            filename: imagePath.split('/').last,
          ),
        );
        imageUrl =
            'https://cloud.appwrite.io/v1/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=677123c00011701cff06&mode=admin';
        imageId = responseImg.$id;
      }

      Map<String, dynamic> data = {
        'nama': nama,
        'harga': harga,
        'deskripsi': deskripsi,
      };

      if (imageUrl != null) {
        data['gambar'] = imageUrl;
        data['gambarId'] = imageId;
      }

      await databases.createDocument(
        databaseId: '677124420023ea7d08c5',
        collectionId: '67712a3e0011f31510f8',
        documentId: ID.unique(),
        data: data,
      );
      print("Product created successfully");
    } on AppwriteException catch (e) {
      print("Error creating product: \${e.message}");
      throw 'Gagal menambahkan produk';
    }
  }

// Memperbarui produk yang ada
  Future<void> updateProduct(
      String id, String nama, String harga, String deskripsi,
      {String? imagePath, String? oldImageId}) async {
    try {
      String? imageUrl;
      String? imageId;

      if (imagePath != null) {
        final responseImg = await storage.createFile(
          bucketId: '67712a26002919139bf8', // Ganti dengan bucket ID Anda
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: imagePath,
            filename: imagePath.split('/').last,
          ),
        );

        imageUrl =
            'https://cloud.appwrite.io/v1/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=677123c00011701cff06&mode=admin';
        imageId = responseImg.$id;

        // Menghapus file lama jika ada
        if (oldImageId != null) {
          await storage.deleteFile(
            bucketId: '67712a26002919139bf8', // Ganti dengan bucket ID Anda
            fileId: oldImageId,
          );
        }
      }

      Map<String, dynamic> data = {
        'nama': nama,
        'harga': harga,
        'deskripsi': deskripsi,
      };

      if (imageUrl != null) {
        data['gambar'] = imageUrl;
        data['gambarId'] = imageId;
      }

      await databases.updateDocument(
        databaseId: '677124420023ea7d08c5',
        collectionId: '67712a3e0011f31510f8',
        documentId: id,
        data: data,
      );
      print("Product updated successfully");
    } on AppwriteException catch (e) {
      print("Error updating product: \${e.message}");
      throw 'Gagal memperbarui produk';
    }
  }

// Menghapus produk
  Future<void> deleteProduct(String id) async {
    try {
      await databases.deleteDocument(
        databaseId: '677124420023ea7d08c5',
        collectionId: '67712a3e0011f31510f8',
        documentId: id,
      );
      print("Product deleted successfully");
    } on AppwriteException catch (e) {
      print("Error deleting product: \${e.message}");
      throw 'Gagal menghapus produk';
    }
  }
}
