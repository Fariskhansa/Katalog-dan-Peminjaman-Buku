import 'package:flutter/material.dart';

import '../models/buku.dart';
import '../pages/halaman_detail_buku.dart';
import '../services/peminjaman_service.dart';

class KartuBuku extends StatelessWidget {
  const KartuBuku({super.key, required this.buku});

  final Buku buku;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: PeminjamanService.instance,
      builder: (context, child) {
        final sedangDipinjam = PeminjamanService.instance.isDipinjam(buku.id);

        final tersedia = buku.tersedia && !sedangDipinjam;

        final sampulUri = buku.sampul == null
            ? null
            : Uri.tryParse(buku.sampul!);

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HalamanDetailBuku(buku: buku),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 92,
                    height: 132,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (sampulUri != null &&
                            (sampulUri.scheme == 'http' ||
                                sampulUri.scheme == 'https'))
                          Image.network(
                            buku.sampul!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _placeholderCover(colors),
                          )
                        else
                          _placeholderCover(colors),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buku.kategori,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          buku.judul,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          buku.penulis,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: tersedia
                                ? colors.tertiaryContainer
                                : colors.errorContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              tersedia ? 'Tersedia' : 'Sedang dipinjam',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: tersedia
                                        ? colors.onTertiaryContainer
                                        : colors.onErrorContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Tahun ${buku.tahun}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _placeholderCover(ColorScheme colors) {
    return ColoredBox(
      color: colors.secondaryContainer,
      child: Icon(
        Icons.menu_book_rounded,
        size: 38,
        color: colors.onSecondaryContainer,
      ),
    );
  }
}
