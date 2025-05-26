// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sistema_peaje/components/filters_button.dart';
import 'package:sistema_peaje/services/auth_service.dart';
import 'package:sistema_peaje/services/api_service.dart';

class StreamVehicular extends StatefulWidget {
  final AuthService auth;

  const StreamVehicular({super.key, required this.auth});

  @override
  State<StreamVehicular> createState() => _StreamVehicularState();
}

class _StreamVehicularState extends State<StreamVehicular> {
  final ApiService _apiService = ApiService();
  List<BarChartGroupData> barData = []; // Datos para el gráfico de barras
  bool isLoading = true;
  String currentFilter = "days";

  @override
  void initState() {
    super.initState();
    fetchVehicleData();
  }

  Future<void> fetchVehicleData() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> apiData;
      if (currentFilter == "days") {
        apiData = await _apiService.fetchStreamVehicularDayData();
      } else if (currentFilter == "weeks") {
        apiData = await _apiService.fetchStreamVehicularweekData();
      } else {
        apiData = await _apiService.fetchStreamVehicularMonthData();
      }

      // Suponiendo que cada item tiene 'id' y 'count'
      final data =
          apiData
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x:
                      entry.key +
                      1, // O usa entry.value['id'] si viene del backend
                  barRods: [
                    BarChartRodData(
                      toY: (entry.value['count'] ?? 0).toDouble(),
                      color: Colors.blue,
                      width: 36,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                ),
              )
              .toList();

      setState(() {
        barData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar los datos: $e')));
    }
  }

  void onFilterSelected(int index) {
    setState(() {
      currentFilter =
          index == 0
              ? "days"
              : index == 1
              ? "weeks"
              : "months";
    });
    fetchVehicleData();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flujo vehicular'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await widget.auth.logout();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FiltersButton(onFilterSelected: onFilterSelected),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Fondo blanco
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: BarChart(
                          BarChartData(
                            barGroups: barData,
                            groupsSpace: 8,
                            maxY:
                                barData.isNotEmpty
                                    ? barData
                                            .map(
                                              (group) =>
                                                  group.barRods.first.toY,
                                            )
                                            .reduce((a, b) => a > b ? a : b) *
                                        1.2
                                    : 0,
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                tooltipPadding: const EdgeInsets.all(8.0),
                                tooltipMargin: 8,
                                getTooltipItem: (
                                  group,
                                  groupIndex,
                                  rod,
                                  rodIndex,
                                ) {
                                  return BarTooltipItem(
                                    '${rod.toY.toStringAsFixed(1)} vehículos',
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Text(
                        'Flujo Vehicular',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
