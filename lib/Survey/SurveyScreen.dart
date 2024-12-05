import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:schood/Help/HelpScreenModify.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/Survey/CreateSurvey.dart';
import 'package:schood/Survey/SurveySummaryScreen.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
              backgroundColor: themeProvider.getBackgroundColor(),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.notifications_none, size: 40, color: AppColors.purpleSchood),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            icon: Container(
              width: 40,
              height: 40,
              child: Icon(Icons.account_circle, size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H1TextApp(text: "Questionnaire"),
            SizedBox(height: 120.0),
             HelpButtonWithArrow( route: SurveySummaryScreen() ,text: "Voir les questionnaires",
             ),HelpButtonWithArrow( route: CreateSurveyScreen() ,text: "Créer un questionnaire",
             ),]))),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 1,
      
    ));
  }
}
