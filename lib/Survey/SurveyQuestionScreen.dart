// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/request/get.dart';
import '../global.dart' as global;
import 'package:schood/main.dart';

class SurveyQuestionsScreen extends StatefulWidget {
  const SurveyQuestionsScreen({super.key});

  @override
  _SurveyQuestionScreenState createState() => _SurveyQuestionScreenState();
}

class _SurveyQuestionScreenState extends State<SurveyQuestionsScreen> {
  late Future<Map<String, dynamic>?> userDataFuture;
  String id = global.globalToken;

  Future<Map<String, dynamic>?> _getSurveyQuestionData(BuildContext context) async {
    final getdata = GetClass();
    final response = await getdata.getData(global.globalToken, "shared/questionnaire/651add2c68a7c93a70fae29a");

    if (response.statusCode == 200) {
      try {
        final surveyMap = jsonDecode(response.body);
        print(surveyMap);
        return surveyMap.cast<String, dynamic>();
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Error fetching data: ${response.statusCode}');
    }
    return null;
  }

  @override
  void initState() {
    userDataFuture = _getSurveyQuestionData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const H1TextApp(
          text: "Questionnaires",
          color: AppColors.backgroundDarkmode,
        ),
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
              child: Icon(Icons.account_circle, size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      ),
      backgroundColor: themeProvider.getBackgroundColor(),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final surveyData = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  // Display questions
                  Column(
                    children: (surveyData['questions'] as List<dynamic>).map((question) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: ${question['title']}'),
                          
                          // Display answers for each question
                          Text('Answers:'),
                          Column(
                            children: (question['answers'] as List<dynamic>).map((answer) {
                              return Text('Title: ${answer['title']}');
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  
                ],
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
