import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '/models/story_brain.dart'; // make sure this path is correct

class EndingScreen extends StatefulWidget {
  final StoryBrain storyBrain;
  final List<Map<String, String>> storyProgress;

  const EndingScreen({
    super.key,
    required this.storyBrain,
    required this.storyProgress,
  });

  @override
  State<EndingScreen> createState() => _EndingScreenState();
}

class _EndingScreenState extends State<EndingScreen> {
  final pdf = pw.Document();

  Future<void> saveAndSharePdf() async {
    try {
      // Build PDF with story progress
      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) => [
            pw.Center(
              child: pw.Text(
                widget.storyBrain.storyTitle,
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            ...widget.storyProgress.map(
              (step) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Story: ${step['story'] ?? ''}"),
                    if (step['choice'] != null && step['choice']!.isNotEmpty)
                      pw.Text("Choice: ${step['choice']}"),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Center(child: pw.Text("Thank you for reading!")),
          ],
        ),
      );

      // Save PDF to temporary directory
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/ending.pdf");
      await file.writeAsBytes(await pdf.save());

      // Share the file
      await Share.shareXFiles([XFile(file.path)],
          text: "Here is your story PDF!");
    } catch (e, st) {
      debugPrint("Error while saving/sharing PDF: $e");
      debugPrintStack(stackTrace: st);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("The End")),
      body: Center(
        child: ElevatedButton(
          onPressed: saveAndSharePdf,
          child: const Text("Save & Share PDF"),
        ),
      ),
    );
  }
}
