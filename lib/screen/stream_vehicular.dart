import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sistema_peaje/components/filters_button.dart';
import 'package:sistema_peaje/services/auth_service.dart';

class StreamVehicular extends StatefulWidget {
  final AuthService auth;

  const StreamVehicular({super.key, required this.auth});

  @override
  State<StreamVehicular> createState() => _StreamVehicularState();
}

class _StreamVehicularState extends State<StreamVehicular> {
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
      // Datos de prueba
      final List<Map<String, double>> mockData =
          currentFilter == "days"
              ? [
                {"time": 1, "count": 10},
                {"time": 2, "count": 15},
                {"time": 3, "count": 20},
                {"time": 4, "count": 8},
                {"time": 5, "count": 11},
                {"time": 6, "count": 12},
                {"time": 7, "count": 25},
              ]
              : currentFilter == "weeks"
              ? [
                {"time": 1, "count": 50},
                {"time": 2, "count": 60},
                {"time": 3, "count": 70},
                {"time": 4, "count": 70},
              ]
              : [
                {"time": 1, "count": 200},
                {"time": 2, "count": 250},
                {"time": 3, "count": 300},
              ];

      // Convertir los datos de prueba a BarChartGroupData
      final data =
          mockData
              .map(
                (point) => BarChartGroupData(
                  x: point['time']!.toInt(),
                  barRods: [
                    BarChartRodData(
                      toY: point['count']!,
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
      canPop: false,
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
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.amber,
              child: FiltersButton(onFilterSelected: onFilterSelected),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                  bottom: 40,
                  left: 40,
                  right: 40,
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.cyanAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: BarChart(
                          BarChartData(
                            barGroups: barData,
                            maxY:
                                barData.isNotEmpty
                                    ? barData
                                            .map(
                                              (group) =>
                                                  group.barRods.first.toY,
                                            )
                                            .reduce((a, b) => a > b ? a : b) *
                                        1.2
                                    : 0, // Ajusta el valor máximo del eje Y para dejar espacio
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
                            gridData: FlGridData(
                              show: false,
                              drawHorizontalLine: true,
                              horizontalInterval:
                                  5, // Intervalo entre líneas horizontales
                              getDrawingHorizontalLine: (value) {
                                return FlLine(strokeWidth: 1);
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                              border: Border.all(color: Colors.grey, width: 1),
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
