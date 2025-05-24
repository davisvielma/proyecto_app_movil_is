import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String dailyUrl = 'https://retoolapi.dev/CjzrjR/daily';
  static const String weeklyUrl = 'https://retoolapi.dev/1xGr6f/weekly';
  static const String monthlyUrl = 'https://retoolapi.dev/ubGxqi/mes';

  Future<List<dynamic>> fetchDailyData() async {
    final response = await http.get(Uri.parse(dailyUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error cargando datos diarios');
    }
  }

  Future<List<dynamic>> fetchWeeklyData() async {
    final response = await http.get(Uri.parse(weeklyUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error cargando datos semanales');
    }
  }

  Future<List<dynamic>> fetchMonthlyData() async {
    final response = await http.get(Uri.parse(monthlyUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error cargando datos mensuales');
    }
  }
}