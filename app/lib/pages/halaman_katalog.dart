import 'package:flutter/material.dart';

import '../models/buku.dart';
import '../services/buku_service.dart';
import '../widgets/kartu_buku.dart';

class HalamanKatalog extends StatefulWidget {
  const HalamanKatalog({super.key, BukuService? service})
    : _service = service ?? const BukuService();

  final BukuService _service;

  @override
  State<HalamanKatalog> createState() => _HalamanKatalogState();
}

class _HalamanKatalogState extends State<HalamanKatalog> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Buku>> _booksFuture;
  String _query = '';
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _booksFuture = widget._service.fetchBooks();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text.trim().toLowerCase();
    });
  }

  void _reloadBooks() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Memuat ulang katalog...')));
    setState(() {
      _booksFuture = widget._service.fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Buku'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang katalog',
            onPressed: _reloadBooks,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temukan bacaan berikutnya',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cari berdasarkan judul atau nama penulis.',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari buku atau penulis',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            onPressed: _searchController.clear,
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Buku>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _ErrorState(
                    message: snapshot.error.toString(),
                    onRetry: _reloadBooks,
                  );
                }

                final books = snapshot.data;
                if (books == null) {
                  return const _EmptyState(
                    message: 'Respons katalog tidak berisi data buku.',
                  );
                }

                final categories =
                    books.map((book) => book.kategori).toSet().toList()..sort();
                final filteredBooks = books
                    .where((book) {
                      final matchesQuery =
                          _query.isEmpty ||
                          book.judul.toLowerCase().contains(_query) ||
                          book.penulis.toLowerCase().contains(_query);
                      final matchesCategory =
                          _selectedCategory == 'Semua' ||
                          book.kategori == _selectedCategory;
                      return matchesQuery && matchesCategory;
                    })
                    .toList(growable: false);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _categoryChip('Semua'),
                          for (final category in categories)
                            _categoryChip(category),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text(
                        '${filteredBooks.length} buku',
                        style: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ),
                    Expanded(
                      child: filteredBooks.isEmpty
                          ? const _EmptyState(
                              message:
                                  'Buku tidak ditemukan. Coba kata kunci lain.',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              itemCount: filteredBooks.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: KartuBuku(buku: filteredBooks[index]),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: _selectedCategory == category,
        onSelected: (_) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 44,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 44,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Katalog gagal dimuat',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
