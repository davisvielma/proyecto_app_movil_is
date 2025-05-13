import 'package:flutter/material.dart';
import 'package:sistema_peaje/services/auth_service.dart';

class HomePage extends StatefulWidget {
  final AuthService auth;

  const HomePage({super.key, required this.auth});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedView = 0; // 0: Total, 1: Tarjeta, 2: Efectivo

  // Datos de ejemplo
  final List<double> dailyTotal = [1200.0, 1500.0, 1800.0, 2100.0, 2400.0, 2700.0, 3000.0];
  final List<double> dailyCard = [400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0];
  final List<double> dailyCash = [800.0, 1000.0, 1200.0, 1400.0, 1600.0, 1800.0, 2000.0];

  final List<double> weeklyTotal = [15000.0, 18000.0, 21000.0, 24000.0];
  final List<double> weeklyCard = [5000.0, 6000.0, 7000.0, 8000.0];
  final List<double> weeklyCash = [10000.0, 12000.0, 14000.0, 16000.0];

  final List<double> monthlyTotal = [80000.0, 85000.0, 90000.0, 95000.0, 100000.0];
  final List<double> monthlyCard = [25000.0, 30000.0, 35000.0, 40000.0, 45000.0];
  final List<double> monthlyCash = [55000.0, 55000.0, 55000.0, 55000.0, 55000.0];

  List<double> _getDailyData() {
    switch (_selectedView) {
      case 1: return dailyCard;
      case 2: return dailyCash;
      default: return dailyTotal;
    }
  }

  List<double> _getWeeklyData() {
    switch (_selectedView) {
      case 1: return weeklyCard;
      case 2: return weeklyCash;
      default: return weeklyTotal;
    }
  }

  List<double> _getMonthlyData() {
    switch (_selectedView) {
      case 1: return monthlyCard;
      case 2: return monthlyCash;
      default: return monthlyTotal;
    }
  }

  String _getCurrentTitle() {
    switch (_selectedView) {
      case 1: return 'Recaudación por Tarjeta';
      case 2: return 'Recaudación en Efectivo';
      default: return 'Recaudación Total';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getCurrentTitle()),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await widget.auth.logout();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToggleButton(0, 'Total'),
                  _buildToggleButton(1, 'Tarjeta'),
                  _buildToggleButton(2, 'Efectivo'),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatCard(
                      title: 'Recaudación Diaria',
                      data: _getDailyData(),
                      period: 'Últimos 7 días',
                      color: _selectedView == 0 ? Colors.blue :
                      _selectedView == 1 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      title: 'Recaudación Semanal',
                      data: _getWeeklyData(),
                      period: 'Últimas 4 semanas',
                      color: _selectedView == 0 ? Colors.blue :
                      _selectedView == 1 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      title: 'Recaudación Mensual',
                      data: _getMonthlyData(),
                      period: 'Últimos 5 meses',
                      color: _selectedView == 0 ? Colors.blue :
                      _selectedView == 1 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 24),
                    _buildSummaryCard(
                      daily: _getDailyData().last,
                      weekly: _getWeeklyData().last,
                      monthly: _getMonthlyData().last,
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

  Widget _buildToggleButton(int index, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedView == index ? Colors.blue : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _selectedView = index;
        });
      },
      child: Text(text),
    );
  }

  Widget _buildStatCard({
    required String title,
    required List<double> data,
    required String period,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              period,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${data[index].toInt()} Bs',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: data[index] / data.reduce((a, b) => a > b ? a : b) * 60,
                          color: color,
                        ),
                        Text(
                          '${index + 1}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required double daily,
    required double weekly,
    required double monthly,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow('Hoy:', '${daily.toInt()} Bs'),
            _buildSummaryRow('Esta semana:', '${weekly.toInt()} Bs'),
            _buildSummaryRow('Este mes:', '${monthly.toInt()} Bs'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}