import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pustaka_mini/models/usulan_buku.dart';
import 'package:pustaka_mini/pages/halaman_profil.dart';
import 'package:pustaka_mini/pages/halaman_usulan_buku.dart';

Future<void> _isiForm(
  WidgetTester tester, {
  String judul = 'Atomic Habits',
  String penulis = 'James Clear',
  String? kategori = 'Pengembangan Diri',
  String alasan = 'Buku pengembangan diri yang banyak dicari mahasiswa.',
}) async {
  await tester.enterText(find.byKey(const Key('field_judul')), judul);
  await tester.enterText(find.byKey(const Key('field_penulis')), penulis);
  if (kategori != null) {
    await tester.tap(find.byKey(const Key('field_kategori')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(kategori).last);
    await tester.pumpAndSettle();
  }
  await tester.enterText(find.byKey(const Key('field_alasan')), alasan);
}

Future<void> _tekanKirim(WidgetTester tester) async {
  final tombol = find.byKey(const Key('tombol_kirim_usulan'));
  await tester.ensureVisible(tombol);
  await tester.tap(tombol);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Form usulan menampilkan pesan error saat semua field kosong', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HalamanUsulanBuku()));

    await _tekanKirim(tester);

    expect(find.text('Judul buku wajib diisi'), findsOneWidget);
    expect(find.text('Penulis wajib diisi'), findsOneWidget);
    expect(find.text('Kategori wajib dipilih'), findsOneWidget);
    expect(find.text('Alasan wajib diisi'), findsOneWidget);
  });

  testWidgets('Form usulan menolak kategori kosong dan alasan pendek', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HalamanUsulanBuku()));

    await _isiForm(tester, kategori: null, alasan: 'Bagus');
    await _tekanKirim(tester);

    expect(find.text('Kategori wajib dipilih'), findsOneWidget);
    expect(find.text('Alasan minimal 10 karakter'), findsOneWidget);
    expect(find.byType(HalamanUsulanBuku), findsOneWidget);
  });

  testWidgets('Form usulan mengembalikan UsulanBuku melalui Navigator.pop', (
    WidgetTester tester,
  ) async {
    UsulanBuku? hasil;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  hasil = await Navigator.push<UsulanBuku>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HalamanUsulanBuku(),
                    ),
                  );
                },
                child: const Text('Buka Form'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka Form'));
    await tester.pumpAndSettle();
    expect(find.byType(HalamanUsulanBuku), findsOneWidget);

    await _isiForm(tester);
    await _tekanKirim(tester);

    expect(find.byType(HalamanUsulanBuku), findsNothing);
    expect(hasil, isNotNull);
    expect(hasil!.judul, 'Atomic Habits');
    expect(hasil!.penulis, 'James Clear');
    expect(hasil!.kategori, 'Pengembangan Diri');
  });

  testWidgets('Profil menampilkan usulan baru setelah form dikirim', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HalamanProfil()));

    expect(find.text('Belum ada usulan buku.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('tombol_buka_form_usulan')));
    await tester.pumpAndSettle();

    await _isiForm(tester);
    await _tekanKirim(tester);

    expect(find.text('Usulan Saya (1)'), findsOneWidget);
    expect(find.text('Atomic Habits'), findsOneWidget);
    expect(
      find.text('Usulan "Atomic Habits" berhasil dikirim.'),
      findsOneWidget,
    );
  });
}
