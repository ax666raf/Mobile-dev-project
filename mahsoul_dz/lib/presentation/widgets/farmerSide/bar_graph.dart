import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mahsoul_dz/data/models/farmerSide/bar_data.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    // initialize bar data
    BarData mybarData = BarData(
      sunAmount: weeklySummary[0],
      monAmount: weeklySummary[1],
      tueAmount: weeklySummary[2],
      wedAmount: weeklySummary[3],
      thuAmount: weeklySummary[4],
      friAmount: weeklySummary[5],
      satAmount: weeklySummary[6],
    );

    mybarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 200,
        minY: 0,
        barGroups: mybarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [BarChartRodData(toY: data.y, color: primaryColor)],
              ),
            )
            .toList(),
      ),
    );
  }
}
