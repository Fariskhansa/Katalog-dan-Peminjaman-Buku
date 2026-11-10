import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:pustaka_mini/services/api_service.dart';

http.Response _json(Object body, [int status = 200]) => http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

void main() {
  group('ApiService dengan MockClient', () {
    test('getDaftarBuku mengubah respons GET /buku menjadi List<Buku>',
        () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), 'http://test.local/buku');
        return _json([
          {
            'id': 1,
            'judul': 'Laskar Pelangi',
            'penulis': 'Andrea Hirata',
            'kategori': 'Novel',
            'tahun_terbit': 2005,
          },
          {
            'id': 2,
            'judul': 'Bumi',
            'penulis': 'Tere Liye',
            'kategori': 'Fantasi',
            'tahun_terbit': 2014,
            'tersedia': false,
          },
        ]);
      });

      final api = ApiService(baseUrl: 'http://test.local/', client: mockClient);
      final books = await api.getDaftarBuku();

      expect(books, hasLength(2));
      expect(books.first.judul, 'Laskar Pelangi');
      expect(books.first.tersedia, isTrue);
      expect(books.last.kategori, 'Fantasi');
      expect(books.last.tersedia, isFalse);
    });

    test('getDetailBuku memanggil GET /buku/:id', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/buku/7');
        return _json({
          'id': 7,
          'judul': 'Filosofi Teras',
          'penulis': 'Henry Manampiring',
          'kategori': 'Pengembangan Diri',
          'tahun_terbit': 2018,
        });
      });

      final api = ApiService(baseUrl: 'http://test.local', client: mockClient);
      final buku = await api.getDetailBuku(7);

      expect(buku.id, 7);
      expect(buku.judul, 'Filosofi Teras');
    });

    test('getKategori mengembalikan daftar kategori dari GET /kategori',
        () async {
      final mockClient = MockClient(
        (request) async => _json(['Fantasi', 'Novel', 'Sejarah']),
      );

      final api = ApiService(baseUrl: 'http://test.local', client: mockClient);

      expect(await api.getKategori(), ['Fantasi', 'Novel', 'Sejarah']);
    });

    test('melempar Exception saat server mengembalikan error 500', () async {
      final mockClient = MockClient(
        (request) async => http.Response('Internal Server Error', 500),
      );

      final api = ApiService(baseUrl: 'http://test.local', client: mockClient);

      await expectLater(
        api.getDaftarBuku(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'pesan',
            contains('HTTP 500'),
          ),
        ),
      );
    });

    test('melempar Exception saat buku tidak ditemukan (404)', () async {
      final mockClient = MockClient(
        (request) async => _json({'error': 'Buku tidak ditemukan.'}, 404),
      );

      final api = ApiService(baseUrl: 'http://test.local', client: mockClient);

      await expectLater(
        api.getDetailBuku(99),
        throwsA(isA<Exception>()),
      );
    });
  });
}
