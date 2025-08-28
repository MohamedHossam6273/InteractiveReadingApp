class StorySummary {
  final String title;
  final String path;
  final String image; // cover image path
  bool isDownloaded; // whether the story is downloaded

  StorySummary({
    required this.title,
    required this.path,
    this.image = 'assets/images/placeholder.png',
    this.isDownloaded = false,
  });
}
