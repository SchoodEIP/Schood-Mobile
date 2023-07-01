import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/utils/BottomBarApp.dart';

class StatsScreen extends StatelessWidget {
  /*final User? Userinfo;
  StatsScreen({required this.Userinfo});
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            "Weekly Stats",
            style: GoogleFonts.inter(
              color: AppColors.purpleSchood,
              fontSize: 22,
            ),
          ),
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
          Text(
            "Past Weeks",
            style: GoogleFonts.inter(
              color: AppColors.purpleSchood,
              fontSize: 22,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarApp(
        index_app: 2,
        //Userinfo: Userinfo,
      ),
    );
  }
}

class StatsGraph extends StatelessWidget {
  final String name;
  final double value;

  const StatsGraph({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 100 - value, // La taille se réduit depuis le haut
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
