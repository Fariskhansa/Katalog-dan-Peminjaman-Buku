import 'package:flutter/material.dart';

import '../models/usulan_buku.dart';

const daftarKategoriUsulan = [
  'Novel',
  'Fantasi',
  'Pengembangan Diri',
  'Sejarah',
  'Romansa',
  'Memoar',
  'Lainnya',
];

class HalamanUsulanBuku extends StatefulWidget {
  const HalamanUsulanBuku({super.key});

  @override
  State<HalamanUsulanBuku> createState() => _HalamanUsulanBukuState();
}

class _HalamanUsulanBukuState extends State<HalamanUsulanBuku> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _penulisController = TextEditingController();
  final _alasanController = TextEditingController();
  String? _kategori;

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  String? _validasiWajib(String? value, String label, {int minLength = 1}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$label wajib diisi';
    }
    if (text.length < minLength) {
      return '$label minimal $minLength karakter';
    }
    return null;
  }

  String? _validasiKategori(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kategori wajib dipilih';
    }
    return null;
  }

  void _kirimUsulan() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    final usulan = UsulanBuku(
      judul: _judulController.text.trim(),
      penulis: _penulisController.text.trim(),
      kategori: _kategori!,
      alasan: _alasanController.text.trim(),
      tanggalUsulan: DateTime.now(),
    );

    Navigator.pop(context, usulan);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Usulan Pengadaan Buku')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Isi data buku yang ingin kamu usulkan untuk ditambahkan ke katalog.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('field_judul'),
                controller: _judulController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Judul buku',
                  prefixIcon: Icon(Icons.menu_book_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    _validasiWajib(value, 'Judul buku', minLength: 3),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('field_penulis'),
                controller: _penulisController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Penulis',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _validasiWajib(value, 'Penulis'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: const Key('field_kategori'),
                initialValue: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final kategori in daftarKategoriUsulan)
                    DropdownMenuItem(value: kategori, child: Text(kategori)),
                ],
                onChanged: (value) => setState(() => _kategori = value),
                validator: _validasiKategori,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('field_alasan'),
                controller: _alasanController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Alasan pengusulan',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    _validasiWajib(value, 'Alasan', minLength: 10),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const Key('tombol_kirim_usulan'),
                onPressed: _kirimUsulan,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Kirim Usulan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
