// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/WeeklyStats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = '';
  String lastName = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.account_circle,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            H1TextApp(
              text:
                  'Bonjour $firstName $lastName\nComment te sens tu aujourd\'hui ?',
            ),
            const WidgetCard(
              height: 216 + 96 + 16 + 16,
              width: 401,
              title: "Stats hebdomadaire",
              link: '/stats',
            ),
            const WidgetCard(
              height: 216,
              width: 401,
              title: "Questionnaires",
              link: '/surveySummary',
            ),
            const WidgetCard(
              height: 216,
              width: 401,
              title: "Messagerie",
              link: '/chat',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 0,
      ),
    );
  }
}

class WidgetCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String link;

  const WidgetCard({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.link,
  });

  Widget getContentWidget() {
    if (link == '/stats') {
      // Return widget specific to '/stats'
      return Expanded(child: StatsWidget());
    } else if (link == '/surveySummary') {
      // Return widget specific to '/surveySummary'
      return Expanded(child: SurveySummaryWidget());
    } else if (link == '/chat') {
      // Return widget specific to '/chat'
      return Expanded(child: ChatWidget());
    } else {
      // Default case or handle other links if needed
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      color: AppColors.purpleSchood,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red, // Set your desired border color here
            width: 2.0, // Set the border width
          ),
        ),
        width: width,
        height: height / 1.45,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2TextApp(text: title, color: AppColors.backgroundLightmode),
            // const Spacer(),
            getContentWidget(),
            
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, link);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    H4TextApp(
                        text: "Voir plus",
                        color: AppColors.backgroundLightmode),
                    Icon(
                      Icons.forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsGraphHomePage(name: "M", value: 40),
              StatsGraphHomePage(name: "T", value: 30),
              StatsGraphHomePage(name: "W", value: 95),
              StatsGraphHomePage(name: "T", value: 79),
              StatsGraphHomePage(name: "F", value: 100),
              StatsGraphHomePage(name: "S", value: 45),
              StatsGraphHomePage(name: "S", value: 100),
            ],
          ),
        ],
      ),
    );
  }
}

class SurveySummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'a',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class ChatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'a',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
