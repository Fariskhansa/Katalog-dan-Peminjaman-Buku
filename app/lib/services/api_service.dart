import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/buku.dart';

/// API client untuk backend Pustaka Mini (Dart Shelf).
///
/// Semua request HTTP ke server lewat class ini. Parameter [client]
/// bisa diisi `MockClient` saat testing supaya tidak perlu server asli.
class ApiService {
  const ApiService({this.baseUrl, this.client});

  final String? baseUrl;
  final http.Client? client;

  static const _timeout = Duration(seconds: 15);

  String get _baseUrl =>
      (baseUrl ?? _defaultBaseUrl).replaceFirst(RegExp(r'/$'), '');

  static String get _defaultBaseUrl {
    const configuredUrl = String.fromEnvironment('API_URL');
    if (configuredUrl.isNotEmpty) {
      return configuredUrl;
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://127.0.0.1:8080';
  }

  Future<dynamic> _get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final request = client?.get(uri) ?? http.get(uri);
    final response = await request.timeout(_timeout);

    if (response.statusCode == 404) {
      throw Exception('Data tidak ditemukan (HTTP 404).');
    }
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (HTTP ${response.statusCode}).');
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  /// GET /buku — daftar seluruh buku.
  Future<List<Buku>> getDaftarBuku() async {
    final decoded = await _get('/buku');
    if (decoded is! List) {
      throw const FormatException('Respons endpoint /buku harus berupa array.');
    }

    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException(
              'Setiap item pada respons /buku harus berupa objek.',
            );
          }
          return Buku.fromJson(item);
        })
        .toList(growable: false);
  }

  /// GET /buku/:id — detail satu buku.
  Future<Buku> getDetailBuku(int id) async {
    final decoded = await _get('/buku/$id');
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Respons endpoint /buku/:id harus berupa objek.',
      );
    }
    return Buku.fromJson(decoded);
  }

  /// GET /kategori — daftar kategori unik.
  Future<List<String>> getKategori() async {
    final decoded = await _get('/kategori');
    if (decoded is! List) {
      throw const FormatException(
        'Respons endpoint /kategori harus berupa array.',
      );
    }
    return decoded.whereType<String>().toList(growable: false);
  }
}
