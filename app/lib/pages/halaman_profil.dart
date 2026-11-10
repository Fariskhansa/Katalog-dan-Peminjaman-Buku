import 'package:flutter/material.dart';

import '../models/usulan_buku.dart';
import 'halaman_usulan_buku.dart';

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({super.key});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  final List<UsulanBuku> _daftarUsulan = [];

  Future<void> _bukaFormUsulan() async {
    final hasil = await Navigator.push<UsulanBuku>(
      context,
      MaterialPageRoute(builder: (_) => const HalamanUsulanBuku()),
    );
    if (!mounted || hasil == null) {
      return;
    }

    setState(() => _daftarUsulan.insert(0, hasil));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usulan "${hasil.judul}" berhasil dikirim.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: colorScheme.secondaryContainer,
              child: Icon(
                Icons.person_rounded,
                size: 44,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Profil Pengguna',
            textAlign: TextAlign.center,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Punya rekomendasi buku yang belum ada di katalog? '
            'Ajukan usulan pengadaan di sini.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            key: const Key('tombol_buka_form_usulan'),
            onPressed: _bukaFormUsulan,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Usulkan Pengadaan Buku'),
          ),
          const SizedBox(height: 24),
          Text(
            'Usulan Saya (${_daftarUsulan.length})',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (_daftarUsulan.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Belum ada usulan buku.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
              ),
            )
          else
            ..._daftarUsulan.map(
              (usulan) => Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book_rounded),
                  title: Text(usulan.judul),
                  subtitle: Text(
                    '${usulan.penulis} · ${usulan.kategori}\n${usulan.alasan}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
