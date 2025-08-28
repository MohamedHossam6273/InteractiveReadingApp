import 'package:flutter/material.dart';
import '../models/story_summary.dart';

class StoryCard extends StatelessWidget {
  final StorySummary summary;
  final VoidCallback onTap;
  final int index; // used to vary height for Pinterest-like layout

  const StoryCard({
    super.key,
    required this.summary,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Different heights depending on index (Pinterest/Windows Phone feel)
    final double imageHeight = 180 + (index % 3) * 40;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image container with variable height
            SizedBox(
              height: imageHeight,
              child: summary.image.isNotEmpty
                  ? Image.asset(
                      summary.image,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.book, size: 50),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                summary.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (summary.isDownloaded)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  'Downloaded',
                  style: TextStyle(fontSize: 12, color: Colors.green[700]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
