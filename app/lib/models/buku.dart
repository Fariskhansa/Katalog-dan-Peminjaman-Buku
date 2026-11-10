class Buku {
  const Buku({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.tahun,
    required this.tersedia,
    this.tanggalMasuk,
    this.sampul,
  });

  final int id;
  final String judul;
  final String penulis;
  final String kategori;
  final int tahun;
  final bool tersedia;
  final DateTime? tanggalMasuk;
  final String? sampul;

  factory Buku.fromJson(Map<String, dynamic> json) {
    final year = json['tahun'] ?? json['tahun_terbit'];
    if (year is! int) {
      throw const FormatException('Tahun buku harus berupa angka.');
    }

    final rawTanggalMasuk = json['tanggalMasuk'] ?? json['tanggal_masuk'];
    final tanggalMasuk = switch (rawTanggalMasuk) {
      null => null,
      String value => DateTime.tryParse(value),
      _ => throw const FormatException(
        'Tanggal masuk buku harus berupa string tanggal.',
      ),
    };
    if (rawTanggalMasuk != null && tanggalMasuk == null) {
      throw const FormatException('Format tanggal masuk buku tidak valid.');
    }

    final rawTersedia = json['tersedia'];
    if (rawTersedia != null && rawTersedia is! bool) {
      throw const FormatException('Status tersedia buku harus berupa boolean.');
    }

    final rawSampul = json['sampul'];
    if (rawSampul != null && rawSampul is! String) {
      throw const FormatException('Sampul buku harus berupa URL string.');
    }

    return Buku(
      id: _requiredValue<int>(json, 'id'),
      judul: _requiredValue<String>(json, 'judul'),
      penulis: _requiredValue<String>(json, 'penulis'),
      kategori: _requiredValue<String>(json, 'kategori'),
      tahun: year,
      tersedia: rawTersedia as bool? ?? true,
      tanggalMasuk: tanggalMasuk,
      sampul: rawSampul as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'penulis': penulis,
    'kategori': kategori,
    'tahun_terbit': tahun,
    'tersedia': tersedia,
    'tanggalMasuk': tanggalMasuk?.toIso8601String(),
    'sampul': sampul,
  };

  static T _requiredValue<T>(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! T) {
      throw FormatException(
        'Data buku "$key" tidak valid atau tidak tersedia.',
      );
    }
    return value;
  }
}
