// lib/screens/library_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/story_brain.dart';
import '../models/story_summary.dart';
import '../helpers/story_loader.dart';
import 'story_page.dart';
import '../widgets/story_card.dart';
import 'download_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<StorySummary>> _storiesFuture;

  @override
  void initState() {
    super.initState();
    _storiesFuture = StoryLoader.loadStories();
  }

  /// Checks if a story has been downloaded by verifying if its folder exists
  bool _isDownloaded(String path) {
    final file = File(path);
    return file.existsSync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Story'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DownloadScreen()),
              ).then((_) {
                // Refresh library after returning from download screen
                setState(() {
                  _storiesFuture = StoryLoader.loadStories();
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<StorySummary>>(
        future: _storiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          }

          final stories = snapshot.data ?? [];
          if (stories.isEmpty) {
            return const Center(child: Text('No stories found'));
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];

                // Determine if this story is downloaded
                final downloaded = story.isDownloaded;

                return Stack(
                  children: [
                    StoryCard(
                      summary: story,
                      index: index,
                      onTap: () async {
                        try {
                          final loaded =
                              await StoryBrain.loadFromAsset(story.path);
                          final brain = StoryBrain(loaded);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StoryPage(storyBrain: brain),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to load story: $e')),
                          );
                        }
                      },
                    ),
                    if (downloaded)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
