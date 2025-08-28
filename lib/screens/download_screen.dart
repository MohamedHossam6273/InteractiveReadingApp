// lib/screens/download_screen.dart
import 'package:flutter/material.dart';
import '../helpers/download_helper.dart';
import '../helpers/remote_loader.dart';
import '../models/remote_story.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late Future<List<RemoteStory>> _storiesFuture;
  final RemoteLoader _remoteLoader = RemoteLoader();

  @override
  void initState() {
    super.initState();
    _storiesFuture = _remoteLoader.fetchRemoteStories(
        'https://mohamedhossam6273.github.io/stories-hosting/stories/index.json'); // Replace with your server URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Stories")),
      body: FutureBuilder<List<RemoteStory>>(
        future: _storiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stories = snapshot.data ?? [];
          if (stories.isEmpty) {
            return const Center(child: Text('No stories found'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              double progress = 0;

              return StatefulBuilder(
                builder: (ctx, setState) => Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          story.coverPath, // ✅ fixed (was coverUrl)
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.book, size: 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          story.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await downloadStory(story, (p) {
                              setState(() => progress = p);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("${story.title} downloaded!")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed: $e")),
                            );
                          }
                        },
                        child: progress == 0
                            ? const Text("Download")
                            : LinearProgressIndicator(value: progress),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
