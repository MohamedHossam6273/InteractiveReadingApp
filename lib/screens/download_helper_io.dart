// lib/screens/download_helper_io.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

Future<void> saveAndSharePdf(List<int> bytes, String filename) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  final xfile = XFile(file.path);
  await Share.shareXFiles([xfile], text: 'Check out the story I created!');
}
