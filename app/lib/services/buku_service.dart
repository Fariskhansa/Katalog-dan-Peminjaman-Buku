import 'package:http/http.dart' as http;

import '../models/buku.dart';
import 'api_service.dart';

/// Service katalog yang dipakai HalamanKatalog.
///
/// Request HTTP-nya sekarang didelegasikan ke [ApiService],
/// jadi seluruh koneksi ke backend terpusat di satu API client.
class BukuService {
  const BukuService({this.baseUrl, this.client});

  final String? baseUrl;
  final http.Client? client;

  ApiService get _api => ApiService(baseUrl: baseUrl, client: client);

  Future<List<Buku>> fetchBooks() => _api.getDaftarBuku();
}
