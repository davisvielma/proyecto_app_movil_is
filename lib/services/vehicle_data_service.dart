import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VehicleDataService {
  Future<List<FlSpot>> fetchVehicleDayData() async {
    final url = 'https://retoolapi.dev/EM5FvM/StreamVehicularDay';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<FlSpot>.from(
        data.map(
          (point) => FlSpot(
            (point['hora'] ?? 0).toDouble(),
            (point['cantidad'] ?? 0).toDouble(),
          ),
        ),
      );
    } else {
      throw Exception('Error al obtener datos del flujo vehicular diario');
    }
  }
}
