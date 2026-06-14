import 'dart:convert';
import 'package:http/http.dart' as http;

class PexelsService {
  static const String _apiKey =
      '6tVGopLJlAQ5Q13VkRJIEK49O2S3uyHOh7l3FY5avSxNNksQgk9DVxom';
  static const String _baseUrl = 'https://api.pexels.com/v1';

  static Future<List<String>> fetchWallpapers({
    String query = 'wallpaper',
    int perPage = 20,
    int page = 1,
  }) async {
    final url = query == 'wallpaper'
        ? '$_baseUrl/curated?per_page=$perPage&page=$page'
         : '$_baseUrl/search?query=$query&per_page=$perPage&page=$page';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final photos = data['photos'] as List;
      return photos.map((p) => p['src']['portrait'] as String).toList();
    } else {
      throw Exception('Failed to load wallpapers');
    }
  }
}