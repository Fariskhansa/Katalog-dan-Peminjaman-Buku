// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pustaka_mini/models/buku.dart';
import 'package:pustaka_mini/pages/halaman_katalog.dart';
import 'package:pustaka_mini/services/buku_service.dart';

void main() {
  final sampleBook = Buku(
    id: 1,
    judul: 'Laskar Pelangi',
    penulis: 'Andrea Hirata',
    kategori: 'Novel',
    tahun: 2005,
    tersedia: true,
    tanggalMasuk: DateTime(2024, 2, 1),
    sampul: 'https://example.com/cover.jpg',
  );

  test('Buku maps API fields and serializes all model fields', () {
    final book = Buku.fromJson({
      'id': 1,
      'judul': 'Laskar Pelangi',
      'penulis': 'Andrea Hirata',
      'kategori': 'Novel',
      'tahun_terbit': 2005,
      'tanggal_masuk': '2024-02-01T00:00:00.000',
      'sampul': 'https://example.com/cover.jpg',
      'tersedia': false,
    });

    expect(book.tahun, 2005);
    expect(book.tanggalMasuk, DateTime(2024, 2, 1));
    expect(book.tersedia, isFalse);
    expect(book.toJson()['tahun_terbit'], 2005);
    expect(book.toJson()['sampul'], 'https://example.com/cover.jpg');
    expect(Buku.fromJson(book.toJson()).toJson(), book.toJson());
  });

  test('Buku accepts current API data with optional fields missing', () {
    final book = Buku.fromJson({
      'id': 2,
      'judul': 'Bumi',
      'penulis': 'Tere Liye',
      'kategori': 'Fantasi',
      'tahun_terbit': 2014,
    });

    expect(book.tersedia, isTrue);
    expect(book.tanggalMasuk, isNull);
    expect(book.sampul, isNull);
  });

  testWidgets('Katalog searches title and filters by category', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HalamanKatalog(
          service: _FakeBukuService([sampleBook, _fantasyBook]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Laskar Pelangi'), findsOneWidget);
    expect(find.text('Bumi'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'andrea');
    await tester.pumpAndSettle();

    expect(find.text('Laskar Pelangi'), findsOneWidget);
    expect(find.text('Bumi'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Fantasi'));
    await tester.pumpAndSettle();

    expect(find.text('Laskar Pelangi'), findsNothing);
    expect(find.text('Bumi'), findsOneWidget);
  });
}

const _fantasyBook = Buku(
  id: 2,
  judul: 'Bumi',
  penulis: 'Tere Liye',
  kategori: 'Fantasi',
  tahun: 2014,
  tersedia: true,
);

class _FakeBukuService extends BukuService {
  _FakeBukuService(this.books);

  final List<Buku> books;

  @override
  Future<List<Buku>> fetchBooks() async => books;
}
