import 'package:http/http.dart' as http;
import 'dart:convert';

class MubertService {
  static const String _baseUrl = 'https://api.mubert.com/v2';
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with actual key

  Future<String> generateMusic(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/TTM'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'text': text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['track_url'];
      } else {
        throw Exception('Failed to generate music: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
