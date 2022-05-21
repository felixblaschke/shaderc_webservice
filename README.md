# shaderc_webservice

Web service that compiles GLSL code to SPIR-V bytecode.

## Usage

- Make sure Dart is installed.
- Make [shaderc](https://github.com/google/shaderc#downloads) locally available.
- Set desired environment variables
- Start server with `dart run`

## Environment variables

`GLSLC_PATH`: Path to your local `glslc` executable. Defaults to `shaderc/bin/glslc`.

Also see [https://pub.dev/packages/shelf_plus#custom-configuration](https://pub.dev/packages/shelf_plus#custom-configuration).