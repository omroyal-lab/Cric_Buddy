import 'dart:io';

Future<void> main() async {
  final root = Directory('build/web');
  if (!await root.exists()) {
    stderr.writeln('Missing build/web directory. Run: flutter build web');
    exitCode = 64;
    return;
  }

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8081;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('Serving CricScore at http://localhost:$port');

  await for (HttpRequest request in server) {
    final filePath = request.uri.path == '/'
        ? 'index.html'
        : request.uri.path.substring(1);
    final file = File('${root.path}/$filePath');

    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      request.response.headers.contentType = ContentType.parse(
        _contentTypeFor(file.path),
      );
      request.response.add(bytes);
      await request.response.close();
    } else {
      final fallback = File('${root.path}/index.html');
      final bytes = await fallback.readAsBytes();
      request.response.statusCode = HttpStatus.ok;
      request.response.headers.contentType = ContentType.html;
      request.response.add(bytes);
      await request.response.close();
    }
  }
}

String _contentTypeFor(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.html')) return 'text/html; charset=utf-8';
  if (lower.endsWith('.js')) return 'application/javascript; charset=utf-8';
  if (lower.endsWith('.css')) return 'text/css; charset=utf-8';
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.svg')) return 'image/svg+xml';
  if (lower.endsWith('.ico')) return 'image/x-icon';
  return 'application/octet-stream';
}
