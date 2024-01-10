// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.account_circle,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            H1TextApp(
              text:
                  'Bonjour $firstName $lastName\nComment te sens tu aujourd\'hui ?',
            ),
            const WidgetCard(
              height: 344,
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
              height: 286,
              width: 401,
              title: "Messagerie",
              link: '/chat',
            ),
            const WidgetCard(
              height: 286,
              width: 401,
              title: "Numéros d'aides",
              link: '/info',
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
    Key? key,
    required this.width,
    required this.height,
    required this.title,
    required this.link,
  });

  Widget getContentWidget() {
    if (link == '/stats') {
      return const Expanded(child: StatsWidget());
    } else if (link == '/surveySummary') {
      return const Expanded(child: SurveySummaryWidget());
    } else if (link == '/chat') {
      return const Expanded(child: ChatWidget());
    } else if (link == '/info') {
      return const Expanded(child: HelpWidget());
    } else {
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
        width: width,
        height: height / 1.45,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2TextApp(text: title, color: AppColors.backgroundLightmode),
            getContentWidget(),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, link);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    H4TextApp(
                      text: "Voir plus",
                      color: AppColors.backgroundLightmode,
                    ),
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
  const StatsWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
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
  const SurveySummaryWidget({Key? key});

  Future<String?> _getStoredSurveyId() async {
    final cacheManager = DefaultCacheManager();
    FileInfo? fileInfo = await cacheManager.getFileFromCache('survey_id');
    if (fileInfo != null && fileInfo.file != null) {
      List<int> bytes = await fileInfo.file!.readAsBytes();
      return utf8.decode(bytes);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getStoredSurveyId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error loading survey ID: ${snapshot.error}');
        }

        String? surveyId = snapshot.data;

        return Container(
          child: Text(
            'Survey $surveyId A Compléter',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(),
        Text(
          'Professeur Math',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          'Professeur Anglais',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          'Professeur Histoire',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}

class HelpWidget extends StatelessWidget {
  const HelpWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(),
        Text(
          'Numéro gratuit',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          'Professionnels de la santé',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          'Numéro d\'urgence',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
