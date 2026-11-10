class UsulanBuku {
  const UsulanBuku({
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.alasan,
    required this.tanggalUsulan,
  });

  final String judul;
  final String penulis;
  final String kategori;
  final String alasan;
  final DateTime tanggalUsulan;

  Map<String, dynamic> toJson() => {
        'judul': judul,
        'penulis': penulis,
        'kategori': kategori,
        'alasan': alasan,
        'tanggal_usulan': tanggalUsulan.toIso8601String(),
      };
}
