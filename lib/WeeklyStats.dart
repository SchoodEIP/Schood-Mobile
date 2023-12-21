// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  /*final User? Userinfo;
  StatsScreen({required this.Userinfo});
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: const Column(
        children: [
          H1TextApp(
              text: "Stats hebdomadaires", color: AppColors.backgroundDarkmode),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsGraph(name: "M", value: 40),
              StatsGraph(name: "T", value: 30),
              StatsGraph(name: "W", value: 95),
              StatsGraph(name: "T", value: 79),
              StatsGraph(name: "F", value: 100),
              StatsGraph(name: "S", value: 45),
              StatsGraph(name: "S", value: 100),
            ],
          ),
          H2TextApp(
              text: "Semaines passées", color: AppColors.backgroundDarkmode),
        ],
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 2,
      ),
    );
  }
}

class StatsGraph extends StatelessWidget {
  final String name;
  final double value;

  const StatsGraph({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 100 - value,
          width: 10,
        ),
        Container(
          height: value,
          width: 10,
          decoration: BoxDecoration(
            color: AppColors.purpleSchood,
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        Text(name),
      ],
    );
  }
}
