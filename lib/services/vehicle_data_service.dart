import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VehicleDataService {
  final String baseUrl;

  VehicleDataService(this.baseUrl);

  Future<List<FlSpot>> fetchVehicleData(String filter) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vehicle-flow?filter=$filter'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<FlSpot>.from(
          data.map(
            (point) =>
                FlSpot(point['time'].toDouble(), point['count'].toDouble()),
          ),
        );
      } else {
        throw Exception('Error al obtener los datos');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }
}
