import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnimatedBarChart extends StatelessWidget {
  final List<double> values;

  const AnimatedBarChart({Key? key, required this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: values.asMap().entries.map((entry) {
          int index = entry.key;
          double value = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                width: 16,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              )
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
      swapAnimationDuration: Duration(milliseconds: 600),
    );
  }
}
