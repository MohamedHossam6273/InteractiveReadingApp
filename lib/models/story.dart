class Story {
  final String storyTitle;
  final String choice1;
  final String choice2;
  final int? next1;
  final int? next2;

  Story({
    required this.storyTitle,
    required this.choice1,
    required this.choice2,
    this.next1,
    this.next2,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      storyTitle: json['storyTitle'],
      choice1: json['choice1'],
      choice2: json['choice2'],
      next1: json['next1'],
      next2: json['next2'],
    );
  }
}