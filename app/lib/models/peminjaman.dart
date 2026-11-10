class Peminjaman {
  final int id;
  final int bukuId;
  final String judulBuku;
  final String penulis;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembali;

  Peminjaman({
    required this.id,
    required this.bukuId,
    required this.judulBuku,
    required this.penulis,
    required this.tanggalPinjam,
    required this.tanggalKembali,
  });

  bool get sudahJatuhTempo {
    return DateTime.now().isAfter(tanggalKembali);
  }
}
