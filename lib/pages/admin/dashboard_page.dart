import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../ui/widgets/my_appbar_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<ChartData> chartData = [
    ChartData('David', 25),
    ChartData('Steve', 38),
    ChartData('Jack', 34),
    ChartData('Others', 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBarWidget(text: "Reportes"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300.0,
            child: SfCircularChart(
              // tooltipBehavior: TooltipBehavior(enable: true),
              // title: ChartTitle(
              //   text: "Productos más vendidos",
              // ),
              // legend: Legend(
              //   isVisible: true,
              //   title: LegendTitle(
              //       text: "Productos"
              //   ),
              // ),
              series: [
                PieSeries<ChartData, String>(
                  dataSource: chartData,
                  pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, {this.color});

  final String x;
  final double y;
  final Color? color;
}
