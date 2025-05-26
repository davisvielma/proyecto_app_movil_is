import 'package:flutter/material.dart';
import 'package:sistema_peaje/screen/stream_vehicular.dart';
import 'package:sistema_peaje/services/auth_service.dart';
import 'package:sistema_peaje/services/api_service.dart';

class HomePage extends StatefulWidget {
  final AuthService auth;
  const HomePage({super.key, required this.auth});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  int _selectedView = 0; // 0: Total, 1: Tarjeta, 2: Efectivo
  bool _isLoading = true;
  String _errorMessage = '';

  List<dynamic> _dailyData = [];
  List<dynamic> _weeklyData = [];
  List<dynamic> _monthlyData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await Future.wait([
        _apiService.fetchDailyData(),
        _apiService.fetchWeeklyData(),
        _apiService.fetchMonthlyData(),
      ]);

      setState(() {
        _dailyData = results[0];
        _weeklyData = results[1];
        _monthlyData = results[2];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar datos: $e';
      });
    }
  }

  List<double> _getDailyValues() {
    if (_dailyData.isEmpty) return [];

    switch (_selectedView) {
      case 1: return _dailyData.map<double>((item) => item['card'].toDouble()).toList();
      case 2: return _dailyData.map<double>((item) => item['cash'].toDouble()).toList();
      default: return _dailyData.map<double>((item) => (item['card'] + item['cash']).toDouble()).toList();
    }
  }

  List<double> _getWeeklyValues() {
    if (_weeklyData.isEmpty) return [];

    switch (_selectedView) {
      case 1: return _weeklyData.map<double>((item) => item['card'].toDouble()).toList();
      case 2: return _weeklyData.map<double>((item) => item['cash'].toDouble()).toList();
      default: return _weeklyData.map<double>((item) => (item['card'] + item['cash']).toDouble()).toList();
    }
  }

  List<double> _getMonthlyValues() {
    if (_monthlyData.isEmpty) return [];

    switch (_selectedView) {
      case 1: return _monthlyData.map<double>((item) => item['card'].toDouble()).toList();
      case 2: return _monthlyData.map<double>((item) => item['cash'].toDouble()).toList();
      default: return _monthlyData.map<double>((item) => (item['card'] + item['cash']).toDouble()).toList();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCurrentTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget.auth.logout();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : Column(
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
                    data: _getDailyValues(),
                    period: 'Últimos ${_dailyData.length} días',
                    color: _selectedView == 0
                        ? Colors.blue
                        : _selectedView == 1
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Recaudación Semanal',
                    data: _getWeeklyValues(),
                    period: 'Últimas ${_weeklyData.length} semanas',
                    color: _selectedView == 0
                        ? Colors.blue
                        : _selectedView == 1
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Recaudación Mensual',
                    data: _getMonthlyValues(),
                    period: 'Últimos ${_monthlyData.length} meses',
                    color: _selectedView == 0
                        ? Colors.blue
                        : _selectedView == 1
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryCard(),
                ],
              ),
            ),
          ),
        ],
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
    if (data.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No hay datos disponibles para $title'),
        ),
      );
    }

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

  Widget _buildSummaryCard() {
    final dailyValues = _getDailyValues();
    final weeklyValues = _getWeeklyValues();
    final monthlyValues = _getMonthlyValues();

    final dailyTotal = dailyValues.isNotEmpty ? dailyValues.last : 0;
    final weeklyTotal = weeklyValues.isNotEmpty ? weeklyValues.last : 0;
    final monthlyTotal = monthlyValues.isNotEmpty ? monthlyValues.last : 0;

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
            _buildSummaryRow('Hoy:', '${dailyTotal.toInt()} Bs'),
            _buildSummaryRow('Esta semana:', '${weeklyTotal.toInt()} Bs'),
            _buildSummaryRow('Este mes:', '${monthlyTotal.toInt()} Bs'),
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
