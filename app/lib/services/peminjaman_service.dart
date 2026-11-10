import 'package:flutter/material.dart';

import '../models/buku.dart';
import '../models/peminjaman.dart';

class PeminjamanService extends ChangeNotifier {
  PeminjamanService._();

  static final PeminjamanService instance = PeminjamanService._();

  final List<Peminjaman> _daftarPinjaman = [];

  List<Peminjaman> get daftarPinjaman => List.unmodifiable(_daftarPinjaman);

  bool isDipinjam(int bukuId) {
    return _daftarPinjaman.any((pinjaman) => pinjaman.bukuId == bukuId);
  }

  void pinjam(Buku buku, {DateTime? tanggal}) {
    if (isDipinjam(buku.id)) {
      throw Exception('Buku ini sedang dipinjam.');
    }

    final tanggalPinjam = tanggal ?? DateTime.now();

    final pinjaman = Peminjaman(
      id: DateTime.now().microsecondsSinceEpoch,
      bukuId: buku.id,
      judulBuku: buku.judul,
      penulis: buku.penulis,
      tanggalPinjam: tanggalPinjam,
      tanggalKembali: tanggalPinjam.add(const Duration(days: 7)),
    );

    _daftarPinjaman.add(pinjaman);
    notifyListeners();
  }

  void kembalikan(int id) {
    _daftarPinjaman.removeWhere((pinjaman) => pinjaman.id == id);

    notifyListeners();
  }
}
