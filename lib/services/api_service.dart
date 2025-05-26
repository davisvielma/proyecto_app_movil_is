import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String dailyUrl = 'https://retoolapi.dev/CjzrjR/daily';
  static const String weeklyUrl = 'https://retoolapi.dev/1xGr6f/weekly';
  static const String monthlyUrl = 'https://retoolapi.dev/ubGxqi/mes';
  static const String streamVehicularDayUrl =
      'https://retoolapi.dev/EM5FvM/StreamVehicularDay';
  static const String streamVehicularWeekUrl =
      'https://retoolapi.dev/Yr1923/StreamVehicularWeek';
  static const String streamVehicularMonthUrl =
      'https://retoolapi.dev/WmXxm7/StreamVehicularMonth';

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

  Future<List<dynamic>> fetchStreamVehicularDayData() async {
    final response = await http.get(Uri.parse(streamVehicularDayUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error cargando datos diarios');
    }
  }

  Future<List<dynamic>> fetchStreamVehicularweekData() async {
    final response = await http.get(Uri.parse(streamVehicularWeekUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error cargando datos diarios');
    }
  }

  Future<List<dynamic>> fetchStreamVehicularMonthData() async {
    final response = await http.get(Uri.parse(streamVehicularMonthUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error cargando datos diarios');
    }
  }
}
