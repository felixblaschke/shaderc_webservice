import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class CompilerService {
  final cacheDirectory = Directory('cache');

  CompilerService() {
    init().ignore();
  }

  Future<void> init() async {
    if (!await cacheDirectory.exists()) {
      await cacheDirectory.create();
    }
    cleanUp();
  }

  void cleanUp() {
    cacheDirectory
        .listSync(recursive: true)
        .forEach((entity) => entity.deleteSync());

    Timer(Duration(hours: 24), () => cleanUp());
  }

  Future<Uint8List> compile(String code) async {
    final input = File('${cacheDirectory.path}/input-${code.hashCode}.glsl');
    final output = File('${cacheDirectory.path}/output-${code.hashCode}.sprv');

    if (await input.exists()) {
      await input.delete();
    }
    if (await output.exists()) {
      return output.readAsBytes();
    }

    await input.writeAsString(code);

    final result = await Process.run(
        Platform.environment['GLSLC_PATH'] ?? 'shaderc/bin/glslc', [
      '--target-env=opengl',
      '-fshader-stage=fragment',
      '-o${output.path}',
      input.path,
    ]);

    if (await input.exists()) {
      await input.delete();
    }

    if (result.exitCode == 0) {
      return output.readAsBytes();
    } else {
      final error =
          result.stderr.toString().replaceAll(input.path, 'code.glsl');
      throw CompileException(error);
    }
  }
}

class CompileException implements Exception {
  final String message;

  CompileException(this.message);

  @override
  String toString() => message;
}
