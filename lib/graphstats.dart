import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({Key? key, required this.moodData, required this.selectedOption, required this.gradient, required this.xbackgroundColor, required this.ybackgroundColor, required this.colorstext}) : super(key: key);

  final Map<String, dynamic> moodData;
  final String selectedOption;
  final List<Color> gradient;
  final Color xbackgroundColor;
  final Color ybackgroundColor;
final colorstext;
  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    print(widget.moodData);
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
        
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (widget.selectedOption != "Semaine") {
      switch (value.toInt()) {
        case 0:
          text = H4TextApp(text: "Ja", color: widget.colorstext);
          break;
        case 2:
          text = H4TextApp(text: "Ma", color: widget.colorstext);
          break;
        case 4:
          text = H4TextApp(text: "Ma", color: widget.colorstext);
          break;
        case 6:
                  text = H4TextApp(text: "Ju", color: widget.colorstext);
          break;
        case 8:
          text = H4TextApp(text: "Se", color: widget.colorstext);
          break;
        case 10:
          text = H4TextApp(text: "No", color: widget.colorstext);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
    } else {
      switch (value.toInt()) {
        case 0:
          text = H4TextApp(text: "Lu", color: widget.colorstext);
          break;
        case 1:
          text = H4TextApp(text: "Ma", color: widget.colorstext);
          break;
        case 2:
          text = H4TextApp(text: "Me", color: widget.colorstext);
          break;
        case 3:
          text = H4TextApp(text: "Je", color: widget.colorstext);
          break;
        case 4:
          text = H4TextApp(text: "Ve", color: widget.colorstext);
          break;
        case 5:
          text = H4TextApp(text: "Sa", color: widget.colorstext);
          break;
        case 6:
          text = H4TextApp(text: "Di", color: widget.colorstext);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case -1:
        text = 'NA';
        break;
      case 0:
        text = '😡';
        break;
      case 1:
        text = '☹️';
        break;
      case 2:
        text = '😐';
        break;
      case 3:
        text = '🙂';
        break;
      case 4:
        text = '😁';
        break;
      default:
        return Container();
    }

    return           H4TextApp(text: text, color: widget.colorstext);
  }

    LineChartData mainData() {
      List<FlSpot> spotsData = [];
      if (widget.selectedOption != "Semaine"){
   for (int i = 0; i < 12; i++) {
    spotsData.add(FlSpot(i.toDouble(), 0));
  }
  widget.moodData.forEach((month, data) {
    int monthIndex = 0;

    switch (month.toLowerCase()) {
      case 'january':
        monthIndex = 0;
        break;
      case 'february':
        monthIndex = 1;
        break;
      case 'march':
        monthIndex = 2;
        break;
      case 'april':
        monthIndex = 3;
        break;
      case 'may':
        monthIndex = 4;
        break;
      case 'june':
        monthIndex = 5;
        break;
      case 'july':
        monthIndex = 6;
        break;
      case 'august':
        monthIndex = 7;
        break;
      case 'september':
        monthIndex = 8;
        break;
      case 'october':
        monthIndex = 9;
        break;
      case 'november':
        monthIndex = 10;
        break;
      case 'december':
        monthIndex = 11;
        break;
      default:

        return;
    }
  
    double average = data['average'];
    spotsData[monthIndex] = FlSpot(monthIndex.toDouble(), average);
  });
      }
      else{  for (int i = 0; i < 7; i++) {
    spotsData.add(FlSpot(i.toDouble(), 0));
  }

  widget.moodData.forEach((month, data) {
    int monthIndex = 0;

    switch (month.toLowerCase()) {
      case 'mon':
        monthIndex = 0;
        break;
      case 'tue':
        monthIndex = 1;
        break;
      case 'wed':
        monthIndex = 2;
        break;
      case 'thu':
        monthIndex = 3;
        break;
      case 'fri':
        monthIndex = 4;
        break;
      case 'sat':
        monthIndex = 5;
        break;
      case 'sun':
        monthIndex = 6;
        break;
      default:
        return;
    }
  
    double average = data['average'];
    spotsData[monthIndex] = FlSpot(monthIndex.toDouble(), average);
  });
      }

    double xmax = widget.selectedOption == "Semaine" ? 6 : 11;
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return  FlLine(
            color: widget.xbackgroundColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return  FlLine(
            color: widget.ybackgroundColor,
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
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: xmax,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: spotsData,

          gradient: LinearGradient(
            colors: widget.gradient,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: widget.gradient
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
