// lib/models/story_brain.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StoryNode {
  final String storyTitle;
  final String? choice1;
  final String? choice2;
  final int? next1;
  final int? next2;
  final bool isEnding; // NEW FIELD

  StoryNode({
    required this.storyTitle,
    this.choice1,
    this.choice2,
    this.next1,
    this.next2,
    this.isEnding = false,
  });

  factory StoryNode.fromJson(Map<String, dynamic> json) {
    return StoryNode(
      storyTitle: json['storyTitle'],
      choice1: json['choice1'],
      choice2: json['choice2'],
      next1: json['next1'],
      next2: json['next2'],
      isEnding: json['isEnding'] ?? false, // default false
    );
  }
}

class Story {
  final String title;
  final List<StoryNode> nodes;

  Story({required this.title, required this.nodes});

  factory Story.fromJson(Map<String, dynamic> json) {
    var nodesJson = json['nodes'] as List;
    List<StoryNode> nodes =
        nodesJson.map((node) => StoryNode.fromJson(node)).toList();
    return Story(title: json['title'], nodes: nodes);
  }
}

class StoryBrain {
  final Story story;

  int _currentNodeIndex = 0;

  StoryBrain(this.story);

  // Added getter for storyTitle
  String get storyTitle => story.title;

  String getStory() => story.nodes[_currentNodeIndex].storyTitle;

  String? getChoice1() => story.nodes[_currentNodeIndex].choice1;

  String? getChoice2() => story.nodes[_currentNodeIndex].choice2;

  void nextStory(int choiceNumber) {
    final node = story.nodes[_currentNodeIndex];
    if (choiceNumber == 1 && node.next1 != null) {
      _currentNodeIndex = node.next1!;
    } else if (choiceNumber == 2 && node.next2 != null) {
      _currentNodeIndex = node.next2!;
    }
  }

  /// ✅ Uses the `isEnding` field from JSON
  bool isEnd() {
    final node = story.nodes[_currentNodeIndex];
    return node.isEnding;
  }

  void restart() => _currentNodeIndex = 0;

  static Future<Story> loadFromAsset(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final data = jsonDecode(jsonString);
    return Story.fromJson(data);
  }
}
