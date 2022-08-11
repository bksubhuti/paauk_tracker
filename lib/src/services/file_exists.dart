import 'dart:io' as io;

Future<bool> fileExists(String filename) async {
  return await io.File(filename).exists();
}
