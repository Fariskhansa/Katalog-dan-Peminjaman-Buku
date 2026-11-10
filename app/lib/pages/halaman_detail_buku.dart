import 'package:flutter/material.dart';

import '../models/buku.dart';
import '../services/peminjaman_service.dart';

class HalamanDetailBuku extends StatelessWidget {
  const HalamanDetailBuku({super.key, required this.buku});

  final Buku buku;

  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final service = PeminjamanService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: AnimatedBuilder(
        animation: service,
        builder: (context, child) {
          final sedangDipinjam = service.isDipinjam(buku.id);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 230,
                    child: buku.sampul != null
                        ? Image.network(
                            buku.sampul!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) {
                              return const Icon(Icons.menu_book, size: 120);
                            },
                          )
                        : const Icon(Icons.menu_book, size: 120),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  buku.judul,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text('Penulis: ${buku.penulis}'),
                const SizedBox(height: 8),

                Text('Kategori: ${buku.kategori}'),
                const SizedBox(height: 8),

                Text('Tahun terbit: ${buku.tahun}'),

                const SizedBox(height: 20),

                Text(
                  sedangDipinjam
                      ? 'Status: Sedang dipinjam'
                      : 'Status: Tersedia',
                  style: TextStyle(
                    color: sedangDipinjam ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: sedangDipinjam
                        ? null
                        : () {
                            try {
                              service.pinjam(buku);

                              final pinjaman = service.daftarPinjaman
                                  .firstWhere((item) => item.bukuId == buku.id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Buku berhasil dipinjam. '
                                    'Kembalikan sebelum '
                                    '${formatTanggal(pinjaman.tanggalKembali)}',
                                  ),
                                ),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                    icon: const Icon(Icons.bookmark_add),
                    label: Text(
                      sedangDipinjam ? 'Sedang Dipinjam' : 'Pinjam Buku',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
