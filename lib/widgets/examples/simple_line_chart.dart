import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Data class for a single line in the chart
class ChartLineData {
  final List<FlSpot> dataPoints;
  final Color color;
  final String label;
  final bool showDots;

  const ChartLineData({
    required this.dataPoints,
    required this.color,
    required this.label,
    this.showDots = true,
  });
}

/// A simple line chart widget example using fl_chart
/// This demonstrates a basic implementation of a line chart with sample data
class SimpleLineChartWidget extends StatelessWidget {
  final List<FlSpot>? dataPoints;
  final String? title;
  final Color? lineColor;
  final bool showDots;
  final bool showGrid;
  final bool isCurved;

  const SimpleLineChartWidget({
    super.key,
    this.dataPoints,
    this.title,
    this.lineColor,
    this.showDots = true,
    this.showGrid = true,
    this.isCurved = true,
  });

  @override
  Widget build(BuildContext context) {
    final spots = dataPoints ?? _getSampleData();
    final color = lineColor ?? Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title!,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          AspectRatio(
            aspectRatio: 1.7,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: showGrid,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: isCurved,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: showDots),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          touchedSpot.y.toStringAsFixed(1),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 6:
        text = const Text('Jul', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;
      case 10:
        text = const Text('Nov', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(meta: meta, child: text);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1k';
        break;
      case 3:
        text = '3k';
        break;
      case 5:
        text = '5k';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style, textAlign: TextAlign.left),
    );
  }

  /// Generate sample data for demonstration
  List<FlSpot> _getSampleData() {
    return const [
      FlSpot(0, 1),
      FlSpot(1, 1.5),
      FlSpot(2, 1.4),
      FlSpot(3, 3.4),
      FlSpot(4, 2),
      FlSpot(5, 2.2),
      FlSpot(6, 1.8),
      FlSpot(7, 3),
      FlSpot(8, 2.8),
      FlSpot(9, 2.6),
      FlSpot(10, 3.9),
      FlSpot(11, 5),
    ];
  }
}

/// Multi-line chart widget that supports multiple lines at once
class MultiLineChartWidget extends StatelessWidget {
  final List<ChartLineData> lines;
  final String? title;
  final bool showGrid;
  final bool isCurved;
  final bool showLegend;

  const MultiLineChartWidget({
    super.key,
    required this.lines,
    this.title,
    this.showGrid = true,
    this.isCurved = true,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title!,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          if (showLegend)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: lines.map((line) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 3,
                        decoration: BoxDecoration(
                          color: line.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(line.label, style: const TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
              ),
            ),
          AspectRatio(
            aspectRatio: 1.7,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: showGrid,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                lineBarsData: lines
                    .map(
                      (line) => LineChartBarData(
                        spots: line.dataPoints,
                        isCurved: isCurved,
                        color: line.color,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: line.showDots),
                        belowBarData: BarAreaData(show: false),
                      ),
                    )
                    .toList(),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final line = lines[touchedSpot.barIndex];
                        return LineTooltipItem(
                          '${line.label}\n${touchedSpot.y.toStringAsFixed(1)}',
                          TextStyle(
                            color: line.color,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 6:
        text = const Text('Jul', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;
      case 10:
        text = const Text('Nov', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(meta: meta, child: text);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1k';
        break;
      case 3:
        text = '3k';
        break;
      case 5:
        text = '5k';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style, textAlign: TextAlign.left),
    );
  }
}

/// Example usage screen
class SimpleLineChartExample extends StatelessWidget {
  const SimpleLineChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Line Chart Example')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Example 1: Default chart with sample data
            const Card(
              margin: EdgeInsets.all(16),
              child: SimpleLineChartWidget(title: 'Monthly Revenue'),
            ),

            // Example 2: Custom color and no grid
            Card(
              margin: const EdgeInsets.all(16),
              child: SimpleLineChartWidget(
                title: 'Expenses Overview',
                lineColor: Colors.red,
                showGrid: false,
                dataPoints: const [
                  FlSpot(0, 2),
                  FlSpot(1, 2.5),
                  FlSpot(2, 2.2),
                  FlSpot(3, 3.5),
                  FlSpot(4, 3),
                  FlSpot(5, 4),
                  FlSpot(6, 3.5),
                  FlSpot(7, 4.2),
                  FlSpot(8, 4),
                  FlSpot(9, 4.5),
                  FlSpot(10, 5),
                  FlSpot(11, 4.8),
                ],
              ),
            ),

            // Example 3: Straight lines (not curved)
            Card(
              margin: const EdgeInsets.all(16),
              child: SimpleLineChartWidget(
                title: 'Savings Goal Progress',
                lineColor: Colors.green,
                isCurved: false,
                showDots: true,
                dataPoints: const [
                  FlSpot(0, 0.5),
                  FlSpot(1, 1),
                  FlSpot(2, 1.2),
                  FlSpot(3, 1.8),
                  FlSpot(4, 2.2),
                  FlSpot(5, 2.8),
                  FlSpot(6, 3),
                  FlSpot(7, 3.5),
                  FlSpot(8, 4),
                  FlSpot(9, 4.3),
                  FlSpot(10, 4.8),
                  FlSpot(11, 5.2),
                ],
              ),
            ),

            // Example 4: Multiple lines chart
            const Card(
              margin: EdgeInsets.all(16),
              child: MultiLineChartWidget(
                title: 'Income vs Expenses',
                lines: [
                  ChartLineData(
                    dataPoints: [
                      FlSpot(0, 3),
                      FlSpot(1, 3.2),
                      FlSpot(2, 3.5),
                      FlSpot(3, 3.8),
                      FlSpot(4, 3.6),
                      FlSpot(5, 4.2),
                      FlSpot(6, 4.5),
                      FlSpot(7, 4.8),
                      FlSpot(8, 5),
                      FlSpot(9, 5.2),
                      FlSpot(10, 5.4),
                      FlSpot(11, 5.5),
                    ],
                    color: Colors.green,
                    label: 'Income',
                  ),
                  ChartLineData(
                    dataPoints: [
                      FlSpot(0, 2),
                      FlSpot(1, 2.2),
                      FlSpot(2, 2.5),
                      FlSpot(3, 2.8),
                      FlSpot(4, 3.2),
                      FlSpot(5, 3.0),
                      FlSpot(6, 3.3),
                      FlSpot(7, 3.5),
                      FlSpot(8, 3.8),
                      FlSpot(9, 3.6),
                      FlSpot(10, 4.0),
                      FlSpot(11, 4.2),
                    ],
                    color: Colors.red,
                    label: 'Expenses',
                  ),
                  ChartLineData(
                    dataPoints: [
                      FlSpot(0, 1),
                      FlSpot(1, 1),
                      FlSpot(2, 1),
                      FlSpot(3, 1),
                      FlSpot(4, 0.4),
                      FlSpot(5, 1.2),
                      FlSpot(6, 1.2),
                      FlSpot(7, 1.3),
                      FlSpot(8, 1.2),
                      FlSpot(9, 1.6),
                      FlSpot(10, 1.4),
                      FlSpot(11, 1.3),
                    ],
                    color: Colors.blue,
                    label: 'Savings',
                    showDots: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
