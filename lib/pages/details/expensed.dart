import 'dart:core';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';

class ExpansedChart extends StatefulWidget {
  final Map<String, double> data;

  const ExpansedChart({Key key, @required this.data}) : super(key: key);

  @override
  _ExpansedChartState createState() => _ExpansedChartState();
}

class _ExpansedChartState extends State<ExpansedChart> {
  List<double> price = [];
  List<String> title = [];

  @override
  void initState() {
    super.initState();
    for (var entry in widget.data.entries) {
      price.add(entry.value);
      title.add(entry.key);
    }
  }

  Box box;

  final ChartType _chartType = ChartType.disc;
  final double _ringStrokeWidth = 32;

  int key = 0;

  @override
  Widget build(BuildContext context) {
    final chart = PieChart(
      key: ValueKey(key),
      dataMap: widget.data,
      animationDuration: Duration(seconds: 2),
      chartRadius: math.min(MediaQuery.of(context).size.width / 1.2, 300),
      initialAngleInDegree: 0,
      chartType: _chartType,
      centerText: "Expansed",
      chartValuesOptions: ChartValuesOptions(
          showChartValues: true, showChartValuesInPercentage: true),
      ringStrokeWidth: _ringStrokeWidth,
      emptyColor: Colors.grey,
      emptyColorGradient: [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Expanded",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth >= 200) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: chart,
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: ListView.separated(
                      itemBuilder: (_, index) =>
                          _item(title[index], price[index]),
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: widget.data.length),
                )
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: chart,
                    margin: EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                  ),
                  // settings,
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _item(String title, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "-" + price.toString(),
            style: TextStyle(fontSize: 15, color: Colors.red),
          ),
        ],
      ),
    );
  }
}