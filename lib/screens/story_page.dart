// lib/screens/story_page.dart
import 'package:flutter/material.dart';
import '../models/story_brain.dart';
import 'ending_screen.dart';

class StoryPage extends StatefulWidget {
  final StoryBrain storyBrain;

  const StoryPage({Key? key, required this.storyBrain}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late StoryBrain _storyBrain;
  final List<Map<String, String>> _storyProgress = [];
  bool _navigatedToEnding = false; // prevent double navigation

  @override
  void initState() {
    super.initState();
    _storyBrain = widget.storyBrain;

    // Store the initial story node
    _storyProgress.add({'story': _storyBrain.getStory(), 'choice': ''});

    // Check immediately if starting node is an ending
    if (_storyBrain.isEnd()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_navigatedToEnding) {
          _openEndingScreen();
        }
      });
    }
  }

  void _nextChoice(int choiceNumber) {
    if (_storyBrain.isEnd() || _navigatedToEnding) return;

    setState(() {
      String? choiceText = choiceNumber == 1
          ? _storyBrain.getChoice1()
          : _storyBrain.getChoice2();

      if (choiceText != null) {
        _storyProgress.last['choice'] = choiceText; // store chosen option
      }

      _storyBrain.nextStory(choiceNumber);

      // store next story node
      _storyProgress.add({'story': _storyBrain.getStory(), 'choice': ''});

      // Check if story ended
      if (_storyBrain.isEnd() && !_navigatedToEnding) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_navigatedToEnding) {
            _openEndingScreen();
          }
        });
      }
    });
  }

  void _restartStory() {
    if (_navigatedToEnding) return;

    setState(() {
      _storyBrain.restart();
      _storyProgress.clear();
      _storyProgress.add({'story': _storyBrain.getStory(), 'choice': ''});

      if (_storyBrain.isEnd()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_navigatedToEnding) {
            _openEndingScreen();
          }
        });
      }
    });
  }

  void _openEndingScreen() {
    _navigatedToEnding = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EndingScreen(
          storyBrain: _storyBrain,
          storyProgress: _storyProgress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final choice1 = _storyBrain.getChoice1();
    final choice2 = _storyBrain.getChoice2();

    return Scaffold(
      appBar: AppBar(title: Text(_storyBrain.story.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Text(
                  _storyBrain.getStory(),
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (!_storyBrain.isEnd() && choice1 != null) ...[
              ElevatedButton(
                onPressed: () => _nextChoice(1),
                child: Text(choice1),
              ),
              const SizedBox(height: 12),
            ],
            if (!_storyBrain.isEnd() && choice2 != null)
              ElevatedButton(
                onPressed: () => _nextChoice(2),
                child: Text(choice2),
              ),
          ],
        ),
      ),
    );
  }
}
