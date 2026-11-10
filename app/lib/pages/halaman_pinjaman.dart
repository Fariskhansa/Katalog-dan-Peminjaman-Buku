import 'package:flutter/material.dart';

import '../models/peminjaman.dart';
import '../services/peminjaman_service.dart';

class HalamanPinjaman extends StatelessWidget {
  const HalamanPinjaman({super.key});

  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }

  void konfirmasiPengembalian(BuildContext context, Peminjaman pinjaman) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Kembalikan Buku?'),
          content: Text(
            'Apakah lu yakin ingin mengembalikan '
            '"${pinjaman.judulBuku}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                PeminjamanService.instance.kembalikan(pinjaman.id);
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buku berhasil dikembalikan.')),
                );
              },
              child: const Text('Kembalikan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = PeminjamanService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Pinjaman Saya')),
      body: AnimatedBuilder(
        animation: service,
        builder: (context, child) {
          final daftar = service.daftarPinjaman;

          if (daftar.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum Ada Pinjaman',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Buku yang lu pinjam akan muncul di sini.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: daftar.length,
            itemBuilder: (context, index) {
              final pinjaman = daftar[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pinjaman.judulBuku,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 6),

                      Text('Penulis: ${pinjaman.penulis}'),

                      const SizedBox(height: 12),

                      Text(
                        'Tanggal pinjam: '
                        '${formatTanggal(pinjaman.tanggalPinjam)}',
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Batas pengembalian: '
                        '${formatTanggal(pinjaman.tanggalKembali)}',
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Chip(
                            label: Text(
                              pinjaman.sudahJatuhTempo
                                  ? 'Terlambat'
                                  : 'Masih dipinjam',
                            ),
                            backgroundColor: pinjaman.sudahJatuhTempo
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                          ),

                          const Spacer(),

                          ElevatedButton(
                            onPressed: () {
                              konfirmasiPengembalian(context, pinjaman);
                            },
                            child: const Text('Kembalikan'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
