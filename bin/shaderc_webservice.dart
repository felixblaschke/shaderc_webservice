import 'dart:io';
import 'dart:typed_data';

import 'package:shaderc_webservice/compiler_service.dart';
import 'package:shelf_plus/shelf_plus.dart';

void main() => shelfRun(init);

Handler init() {
  var app = Router().plus;

  final compilerService = CompilerService();

  app.get('/', () => File('html/index.html'));

  app.post('/compile', (Request request) async {
    final code = await request.body.asString;
    Uint8List? result;

    try {
      result = await compilerService.compile(code);
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }

    return result;
  });

  return app;
}
