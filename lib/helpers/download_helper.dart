import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/remote_story.dart';

Future<void> downloadStory(
  RemoteStory story,
  Function(double) onProgress,
) async {
  final dir = await getApplicationDocumentsDirectory();
  final storyDir = Directory('${dir.path}/stories/${story.title}');
  if (!await storyDir.exists()) {
    await storyDir.create(recursive: true);
  }

  // ✅ Base URL for your hosted files
  const String baseUrl = "https://mohamedhossam6273.github.io/stories-hosting/";

  // ✅ Correctly use storyPath and coverPath from RemoteStory
  final String storyUrl = "$baseUrl${story.storyPath}";
  final String coverUrl = "$baseUrl${story.coverPath}";

  // ✅ Download JSON and image concurrently
  await Future.wait<void>([
    Dio().download(
      storyUrl,
      '${storyDir.path}/story.json',
      onReceiveProgress: (received, total) {
        if (total != -1) {
          onProgress(received / total);
        }
      },
    ),
    Dio().download(
      coverUrl,
      '${storyDir.path}/cover.jpg',
      onReceiveProgress: (received, total) {
        // Optional: you can also track cover download progress
      },
    ),
  ]);
}
