import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracker_app/components/fitted_text.dart';

class IndividualBar {
  final int x;
  final double y;

  IndividualBar({required this.x, required this.y});
}

class BarData {
  final List<double> values;
  final List<String> labels;

  BarData({required this.values, required this.labels});

  List<IndividualBar> bars = [];

  void initBarData() {
    for (int i = 0; i < values.length; i++) {
      bars.add(IndividualBar(x: i, y: values[i]));
    }
  }
}

class MyBarGraph extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  MyBarGraph({super.key, required this.values, required this.labels});
  final f = NumberFormat.compact();
  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(values: values, labels: labels);
    barData.initBarData();

    return BarChart(BarChartData(
      maxY: max(values.reduce(max), 0.001),
      minY: 0,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: max(values.reduce(max)/2, 0.001),
                reservedSize: 40,
            showTitles: true,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              axisSide: meta.axisSide,
              child: FittedText(
                text: f.format(value),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          )),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: FittedText(
                          text: labels[(value).toInt()],
                          style: Theme.of(context).textTheme.displayMedium));
                }),
          )),
      barGroups: barData.bars
          .map((data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(
                    toY: data.y, color: Theme.of(context).colorScheme.primary)
              ]))
          .toList(),
    ));
  }
}

class TitledBarGraph extends StatelessWidget {
  String title;
  double? height;
  List<double> values;
  List<String> labels;
  TitledBarGraph(
      {super.key,
      required this.title,
      this.height,
      required this.values,
      required this.labels});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: AutoSizeText(
          title,
          maxLines: 1,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Center(
        child: SizedBox(
          height: height,
          child: MyBarGraph(values: values, labels: labels),
        ),
      )
    ]);
  }
}
