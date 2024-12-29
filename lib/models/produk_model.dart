// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProdukModel {
  final String id;
  final String nama;
  final String harga;
  final String deskripsi;
  final String? gambar;
  final String? gambarId;
  ProdukModel({
    required this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
    required this.gambarId,
  });

  
  factory ProdukModel.fromMap(Map<String, dynamic> map) {
    return ProdukModel(
      id: map['\$id'] as String,
      nama: map['nama'] as String,
      harga: map['harga'] as String,
      deskripsi: map['deskripsi'] as String,
      gambar: map['gambar'] as String,
      gambarId: map['gambarId'] as String,
    );
  }

 
}
