class RemoteStory {
  final String title;
  final String description;
  final String storyPath; // renamed from path
  final String coverPath; // renamed from image

  RemoteStory({
    required this.title,
    required this.description,
    required this.storyPath,
    required this.coverPath,
  });

  factory RemoteStory.fromJson(Map<String, dynamic> json) {
    return RemoteStory(
      title: json['title'],
      description: json['description'],
      storyPath: json['storyPath'], // must match your JSON key
      coverPath: json['coverPath'], // must match your JSON key
    );
  }
}
