import 'dart:convert';
import 'dart:io';

import 'package:pustaka_mini_server/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late Handler handler;

  setUpAll(() async {
    handler = createHandler(await loadBooks());
  });

  test('GET /buku mengembalikan minimal 12 buku dalam JSON', () async {
    final response =
        await handler(Request('GET', Uri.parse('http://localhost/buku')));
    final body = jsonDecode(await response.readAsString()) as List<dynamic>;

    expect(response.statusCode, HttpStatus.ok);
    expect(response.headers['content-type'], contains('application/json'));
    expect(response.headers['access-control-allow-origin'], '*');
    expect(body, hasLength(greaterThanOrEqualTo(12)));
    expect(body.first, containsPair('id', 1));
  });

  test('OPTIONS merespons preflight CORS', () async {
    final response = await handler(
      Request('OPTIONS', Uri.parse('http://localhost/buku')),
    );

    expect(response.statusCode, HttpStatus.noContent);
    expect(response.headers['access-control-allow-methods'], 'GET, OPTIONS');
  });

  test('GET /buku/:id mengembalikan buku dengan ID yang sesuai', () async {
    final response = await handler(
      Request('GET', Uri.parse('http://localhost/buku/3')),
    );
    final body =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;

    expect(response.statusCode, HttpStatus.ok);
    expect(body['id'], 3);
    expect(body['judul'], 'Negeri 5 Menara');
  });

  test('GET /buku/:id mengembalikan 404 untuk ID yang tidak ditemukan',
      () async {
    final response = await handler(
      Request('GET', Uri.parse('http://localhost/buku/999')),
    );

    expect(response.statusCode, HttpStatus.notFound);
    expect(jsonDecode(await response.readAsString()),
        containsPair('error', isA<String>()));
  });

  test('GET /buku/:id mengembalikan 400 untuk ID yang bukan angka', () async {
    final response = await handler(
      Request('GET', Uri.parse('http://localhost/buku/abc')),
    );

    expect(response.statusCode, HttpStatus.badRequest);
  });

  test('GET /kategori mengembalikan kategori unik yang terurut', () async {
    final response = await handler(
      Request('GET', Uri.parse('http://localhost/kategori')),
    );
    final body = jsonDecode(await response.readAsString()) as List<dynamic>;

    expect(response.statusCode, HttpStatus.ok);
    expect(body, containsAll(['Novel', 'Fantasi', 'Memoar']));
    expect(body.toSet(), hasLength(body.length));
    expect(body, orderedEquals([...body]..sort()));
  });
}
