import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';

class PerformanceChartCard extends StatelessWidget {
  final String title;
  final List<FlSpot> dataPoints;
  final Color lineColor;
  final double minX;
  final double maxX;

  const PerformanceChartCard({
    super.key,
    required this.title,
    required this.dataPoints,
    required this.lineColor,
    required this.minX,
    required this.maxX,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.0.responsive(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.responsive(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.responsive(context)),
            SizedBox(
              height: 200.responsive(context),
              child: dataPoints.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : LineChart(
                      LineChartData(
                        minX: minX,
                        maxX: maxX,
                        minY: 0,
                        maxY: 100,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: theme.dividerColor.withValues(alpha: 0.5),
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: const FlTitlesData(
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: dataPoints,
                            isCurved: true,
                            color: lineColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: lineColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
