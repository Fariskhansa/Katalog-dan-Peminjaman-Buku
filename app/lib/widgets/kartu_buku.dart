import 'package:flutter/material.dart';

import '../models/buku.dart';

class KartuBuku extends StatelessWidget {
  const KartuBuku({super.key, required this.buku});

  final Buku buku;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final sampulUri = buku.sampul == null ? null : Uri.tryParse(buku.sampul!);

    return Card(
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
                      errorBuilder: (context, error, stackTrace) =>
                          _placeholderCover(colors),
                    )
                  else
                    _placeholderCover(colors),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        child: Text(
                          '${buku.tahun}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
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
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: buku.tersedia
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
                        buku.tersedia ? 'Tersedia' : 'Sedang dipinjam',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: buku.tersedia
                              ? colors.onTertiaryContainer
                              : colors.onErrorContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (buku.tanggalMasuk != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Masuk ${_formatDate(buku.tanggalMasuk!)}',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
