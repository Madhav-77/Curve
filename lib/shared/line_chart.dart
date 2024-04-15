import 'dart:ui';

import 'package:Curve/resources/values/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineChart extends StatefulWidget {
  String chart_type;
  LineChart(this.chart_type);
  @override
  LineChartState createState() => LineChartState();
}

class LineChartState extends State<LineChart> {
  void initState() {
    setChartTypeData();
    super.initState();
  }
  Color chart_color = Color(0xFFFFFFFF);
  String chart_name = "";
  setChartTypeData(){
    switch (widget.chart_type) {
      case "active":
        chart_color = AppColors.ACTIVE_COLOR;
        chart_name = "Active";
        break;
      case "confirmed":
        chart_color = AppColors.CONFIRMED_COLOR;
        chart_name = "Confirmed";
        break;
      case "recovered":
        chart_color = AppColors.RECOVERED_COLOR;
        chart_name = "Recovered";
        break;
      case "deceased":
        chart_color = AppColors.DECEASED_COLOR;
        chart_name = "Deceased";
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) { 
    final List<ChartData> chartData = [
            ChartData(1, 10),
            ChartData(2, 535),
            ChartData(3, 6231),
            ChartData(4, 45678),
            ChartData(5, 54211),
            ChartData(6, 32145),
            ChartData(7, 22012),
            ChartData(8, 10235),
            ChartData(9, 3549),
            ChartData(10, 1237),
            ChartData(11, 597),
            ChartData(12, 43)
        ];
    // TODO: implement build
     return Scaffold(
            body: Center(
                child: Container(
                    child: SfCartesianChart(
                        series: <CartesianSeries>[
                            // Renders line chart
                            LineSeries<ChartData, int>(
                                dataSource: chartData,
                                color: chart_color,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y
                            )
                        ],
                        primaryXAxis: CategoryAxis(
                            title: AxisTitle(
                                text: chart_name,
                                textStyle: TextStyle(
                                    color: chart_color,
                                    fontWeight: FontWeight.bold
                                )
                            )
                        )
                    )
                )
            )
        );
    }
}

class ChartData {
    ChartData(this.x, this.y);
    final int x;
    final double y;
}
