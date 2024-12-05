import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:schood/Help/HelpScreenModify.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/Survey/CreateSurvey.dart';
import 'package:schood/Survey/SurveyQuestionScreen.dart';
import 'package:schood/Survey/SurveySeeAnswers.dart';
import 'package:schood/Survey/SurveySummaryScreen.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class SurveySummaryAnswersScreen extends StatefulWidget {
  const SurveySummaryAnswersScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _SurveySummaryAnswersScreenState createState() => _SurveySummaryAnswersScreenState();
}

class _SurveySummaryAnswersScreenState extends State<SurveySummaryAnswersScreen> {
  @override
  Widget build(BuildContext context) {
    final String id = widget.id;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
           appBar: AppBar(
        backgroundColor: themeProvider.getBackgroundColor(),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context); // Retour à l'écran précédent
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: AppColors.purpleSchood,
                  ),
                  const SizedBox(width: 8),
                  H4TextApp(
                    text: "Retour",
                    color: themeProvider.getTextColor(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const H1TextApp(text: "Questionnaire"),
              const SizedBox(height: 120.0),
              HelpButtonWithArrow(
                route: SurveyQuestionsScreen(idsurvey: id),
                text: "Voir le questionnaire",
              ),
              HelpButtonWithArrow(

                route: SurveySeeAnswersScreen(id: id),
                text: "Voir les réponses",
              ),
            ],
          ),
        ),
      ),
     
    );
  }
}
