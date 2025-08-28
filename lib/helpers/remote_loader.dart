// lib/helpers/remote_loader.dart
import 'package:dio/dio.dart';
import '../models/remote_story.dart';

class RemoteLoader {
  final Dio _dio;

  RemoteLoader({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetch the list of remote stories from a JSON index URL
  Future<List<RemoteStory>> fetchRemoteStories(String indexUrl) async {
    try {
      final response = await _dio.get(indexUrl);

      // Ensure the response is a List
      if (response.data is! List) {
        throw Exception('Invalid data format: Expected a list of stories');
      }

      final List<dynamic> dataList = response.data;
      return dataList
          .map((json) => RemoteStory.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Failed to fetch remote stories: $e');
      return [];
    }
  }
}
