import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/buku.dart';

class BukuService {
  const BukuService({this.baseUrl});

  final String? baseUrl;

  String get _baseUrl => baseUrl ?? _defaultBaseUrl;

  static String get _defaultBaseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) {
      return configuredUrl;
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://127.0.0.1:8080';
  }

  Future<List<Buku>> fetchBooks() async {
    final baseUrl = _baseUrl.replaceFirst(RegExp(r'/$'), '');
    final response = await http
        .get(Uri.parse('$baseUrl/buku'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat katalog (HTTP ${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body);
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
}
