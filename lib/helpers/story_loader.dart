// lib/helpers/story_loader.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/story_summary.dart';

class StoryLoader {
  /// Load all stories: local assets + downloaded stories
  static Future<List<StorySummary>> loadStories() async {
    List<StorySummary> summaries = [];

    // 1️⃣ Load built-in asset stories
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final assetStories = manifestMap.keys
          .where(
              (key) => key.contains('assets/stories/') && key.endsWith('.json'))
          .toList();

      for (String path in assetStories) {
        try {
          final storyContent = await rootBundle.loadString(path);
          if (storyContent.trim().isEmpty) continue;

          final Map<String, dynamic> storyJson = json.decode(storyContent);
          summaries.add(
            StorySummary(
              title: storyJson['title'] ?? 'بدون عنوان',
              path: path,
              image: storyJson['image'] ?? 'assets/images/placeholder.png',
              isDownloaded: false,
            ),
          );
        } catch (_) {
          // Ignore corrupted or empty files
        }
      }
    } catch (e) {
      print('⚠️ Failed to load asset stories: $e');
    }

    // 2️⃣ Load downloaded stories from app documents
    try {
      final dir = await getApplicationDocumentsDirectory();
      final downloadedDir = Directory('${dir.path}/stories');

      if (await downloadedDir.exists()) {
        final folders = downloadedDir.listSync().whereType<Directory>();

        for (final folder in folders) {
          final storyFile = File('${folder.path}/story.json');
          final imageFile = File('${folder.path}/cover.jpg');

          if (await storyFile.exists()) {
            final content = await storyFile.readAsString();
            final Map<String, dynamic> storyJson = json.decode(content);

            summaries.add(
              StorySummary(
                title: storyJson['title'] ?? 'بدون عنوان',
                path: storyFile.path,
                image: await imageFile.exists()
                    ? imageFile.path
                    : 'assets/images/placeholder.png',
                isDownloaded: true,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('⚠️ Failed to load downloaded stories: $e');
    }

    return summaries;
  }
}
