import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/Survey/SurveyQuestionScreen.dart';
import 'package:schood/Survey/SurveySummaryAnswerScreen.dart';

import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/request/get.dart';
import '../global.dart' as global;
import 'package:schood/main.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:typed_data';

class SurveySummaryScreen extends StatefulWidget {
  const SurveySummaryScreen({Key? key});

  @override
  _SurveySummaryState createState() => _SurveySummaryState();
}

class _SurveySummaryState extends State<SurveySummaryScreen> {
  String id = global.globalToken;
  List<Map<String, dynamic>> questionnairesList = [];

  @override
  void initState() {
    _getSurveyData(context);
    super.initState();
  }

  Future<void> _getSurveyData(BuildContext context) async {
    final getdata = GetClass();
    final response = await getdata.getData(global.globalToken, "shared/questionnaire");
    if (response.statusCode == 200) {
      try {
        final List<dynamic> surveyList = jsonDecode(response.body);
        //print(response.body);

        setState(() {
          questionnairesList = surveyList.expand((survey) {
            final fromDate = survey['fromDate'];
            final toDate = survey['toDate'];
            final List<dynamic> questionnaires = survey['questionnaires'];
            return questionnaires
                .map((questionnaire) {
                  return {
                    'id': questionnaire['_id'],
                    'title': questionnaire['title'],
                    'fromDate': fromDate,
                    'toDate': toDate,
                  };
                }).toList();
          }).toList();
        });

      } catch (e) {
        print('Erreur lors du décodage JSON: $e');
      }
    } else {
      print('Erreur lors de la récupération des données: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
  backgroundColor: themeProvider.getBackgroundColor(),
  elevation: 0.0,
  automaticallyImplyLeading: false,
  title: global.role == "teacher"
      ? InkWell(
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
        )
      : null, // Pas de titre s'il n'y a pas de rôle "teacher"
  actions: global.role != "teacher"
      ? [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.notifications_none,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
          IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/profile');
      },
      icon: Container(
        width: 40, // Ajustez la taille selon vos besoins
        height: 40, // Ajustez la taille selon vos besoins
        child: global.idimageprofil != ""
            ? ClipOval(
                child: Image.network(
                  global.idimageprofil,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.account_circle,
                size: 40,
                color: AppColors.purpleSchood,
              ),
      ),
        )
        ]
      : null, // Aucune action si le rôle est "teacher"
),

      backgroundColor: themeProvider.getBackgroundColor(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: H1TextApp(
              text: "Historique",
              color: themeProvider.getTextColor(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: questionnairesList.map((questionnaire) {
                  final fromDate = DateTime.parse(questionnaire['fromDate']);
                  final toDate = DateTime.parse(questionnaire['toDate']);
                  final now = DateTime.now();

                  final isExpired = now.isAfter(toDate);

                  return ListTile(
                    title: H3TextApp(
                      text: questionnaire['title'],
                      color: isExpired ? AppColors.redSchood : null,
                    ),
                    subtitle: H4TextApp(
                      text: 'Du ${_formatDate(questionnaire['fromDate'])} au ${_formatDate(questionnaire['toDate'])}',
                      color: isExpired ? AppColors.redSchood : null,
                    ),
                    onTap: () {
  if (isExpired && global.role != "teacher") {
    // Si le questionnaire est expiré et que l'utilisateur n'est pas un enseignant, désactivez le tap
    return;
  }

  // Si l'utilisateur est enseignant ou que le questionnaire n'est pas expiré
  if (global.role == "teacher") {
    // Naviguez vers la page des réponses du questionnaire pour les enseignants
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveySummaryAnswersScreen(
          id: questionnaire['id'], // Passez l'ID du questionnaire
        ),
      ),
    );
  } else {
    // Naviguez vers la page des questions du questionnaire pour les autres rôles
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyQuestionsScreen(
          idsurvey: questionnaire['id'],
        ),
      ),
    );
  }
},

                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 1,
      ),
    );
  }

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day/$month/$year";
  }
}
