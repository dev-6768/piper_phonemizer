import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

/// Unzips 'espeak-ng-data.zip' from assets to a folder in application documents directory.
/// Returns the path to the extracted folder.
Future<String> unzipEspeakData() async {
  // Get application documents directory
  final appDocDir = await getApplicationDocumentsDirectory();
  final targetDir = Directory('${appDocDir.path}/espeak-ng-data');

  // If folder already exists, skip extraction
  if (await targetDir.exists()) return targetDir.path;

  await targetDir.create(recursive: true);

  // Load zip from assets
  final byteData = await rootBundle.load('assets/espeak-ng-data.zip');
  final bytes = byteData.buffer.asUint8List();

  // Decode the zip
  final archive = ZipDecoder().decodeBytes(bytes);

  // Extract all files
  for (final file in archive) {
    final filePath = '${targetDir.path}/${file.name}';
    if (file.isFile) {
      final outFile = File(filePath);
      await outFile.create(recursive: true);
      await outFile.writeAsBytes(file.content as List<int>);
    } else {
      await Directory(filePath).create(recursive: true);
    }
  }

  return targetDir.path;
}
