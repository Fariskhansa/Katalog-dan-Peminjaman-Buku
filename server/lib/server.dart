import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<List<Map<String, dynamic>>> loadBooks({
  String path = 'data/buku.json',
}) async {
  final jsonText = await File(path).readAsString();
  final decoded = jsonDecode(jsonText);
  if (decoded is! List) {
    throw const FormatException('Data buku harus berupa array JSON.');
  }

  return decoded.map((book) {
    if (book is! Map<String, dynamic>) {
      throw const FormatException('Setiap data buku harus berupa objek JSON.');
    }
    return book;
  }).toList(growable: false);
}

Handler createHandler(List<Map<String, dynamic>> books) {
  final router = Router();

  router.get('/buku', (Request request) {
    return _jsonResponse(books);
  });

  router.get('/buku/<id>', (Request request, String id) {
    final bookId = int.tryParse(id);
    if (bookId == null) {
      return _jsonResponse(
        {'error': 'ID buku harus berupa angka.'},
        statusCode: HttpStatus.badRequest,
      );
    }

    for (final book in books) {
      if (book['id'] == bookId) {
        return _jsonResponse(book);
      }
    }

    return _jsonResponse(
      {'error': 'Buku tidak ditemukan.'},
      statusCode: HttpStatus.notFound,
    );
  });

  router.get('/kategori', (Request request) {
    final categories = books
        .map((book) => book['kategori'])
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
    return _jsonResponse(categories);
  });

  return Pipeline().addMiddleware(_corsMiddleware).addHandler(router.call);
}

Middleware get _corsMiddleware => (Handler innerHandler) {
      return (Request request) async {
        if (request.method == 'OPTIONS') {
          return Response(HttpStatus.noContent, headers: _corsHeaders);
        }

        final response = await innerHandler(request);
        return response.change(headers: _corsHeaders);
      };
    };

const _corsHeaders = {
  'access-control-allow-origin': '*',
  'access-control-allow-methods': 'GET, OPTIONS',
  'access-control-allow-headers': 'Origin, Content-Type, Accept',
};

Response _jsonResponse(Object body, {int statusCode = HttpStatus.ok}) {
  return Response(
    statusCode,
    body: jsonEncode(body),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}
