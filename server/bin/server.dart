import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:pustaka_mini_server/server.dart';

Future<void> main(List<String> arguments) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final books = await loadBooks();
  final handler = createHandler(books);
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);

  stdout.writeln(
      'Server berjalan di http://${server.address.host}:${server.port}');
}
