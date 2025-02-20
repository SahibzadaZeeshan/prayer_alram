import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimesService {
  Future<List<dynamic>> fetchPrayerTimes(
      double latitude,
      double longitude,
      int month,
      int year) async {
    final url = 'http://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&method=2&month=$month&year=$year';

    try {
      final response = await http.get(Uri.parse(url));

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }
}

