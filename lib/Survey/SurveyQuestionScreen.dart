import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/request/post.dart';
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
  Map<String, bool> isCheckedMap = {};
  String id = global.globalToken;
  late PostClass postClass;

  Future<Map<String, dynamic>?> _getSurveyQuestionData(BuildContext context) async {
    final getdata = GetClass();
    final response = await getdata.getData(
        global.globalToken, "shared/questionnaire/651add2c68a7c93a70fae29a");

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
    postClass = PostClass(); // Initialize the PostClass
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
              child: Icon(Icons.account_circle,
                  size: 40, color: AppColors.purpleSchood),
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
                children: [
                  Column(
                    children: [
                      for (var question
                          in (surveyData['questions'] as List<dynamic>))
                        if (question != null)
                          Column(
                            children: [
                              Text(
                                '${question['title']}',
                                style: const TextStyle(
                                    color: AppColors.purpleSchood,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Column(
                                children: [
                                  for (var answer
                                      in (question['answers'] as List<dynamic>))
                                    if (answer != null)
                                      CheckboxListTile(
                                        title: Text(
                                          '${answer['title']}    ',
                                          style: const TextStyle(
                                              color: AppColors.purpleSchood,
                                              fontSize: 22,
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                        value: isCheckedMap[
                                                '${answer['title']}'] ??
                                            false,
                                        onChanged: (newValue) {
                                          setState(() {
                                            isCheckedMap[
                                                    '${answer['title']}'] =
                                                newValue!;
                                          });
                                        },
                                      ),
                                ],
                              ),
                            ],
                          ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      List<dynamic> selectedAnswers = [];
                      for (var question in (surveyData['questions']
                          as List<dynamic>)) {
                        for (var answer in (question['answers']
                            as List<dynamic>)) {
                          if (isCheckedMap['${answer['title']}'] == true) {
                            selectedAnswers.add(answer);
                          }
                        }
                      }

                      // Post the selected data using the PostClass
                      postClass.postData(context, selectedAnswers, 'student/questionnaire/654841872805a359ff24ccdb');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.purpleSchood,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: Text('Envoyer les réponses'),
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
