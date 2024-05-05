import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/request/post.dart';
import 'package:schood/request/patch.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/request/get.dart';
import '../global.dart' as global;
import 'package:schood/main.dart';

class SurveyQuestionsScreen extends StatefulWidget {
  final String id;

  const SurveyQuestionsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _SurveyQuestionScreenState createState() => _SurveyQuestionScreenState();
}

class _SurveyQuestionScreenState extends State<SurveyQuestionsScreen> {
  late Future<Map<String, dynamic>?> userDataFuture;
  Map<String, bool> isCheckedMap = {};
  String id = global.globalToken;
  late PostClass postClass;
  late PatchClass patchClass;

_sendform(){
  final postdata = PostClass();
  //var data{};
  //Response response = await postdata.postDataAuth(context, , url)
}
  Future<Map<String, dynamic>?> _getSurveyQuestionData(
      BuildContext context) async {
    final getdata = GetClass();
    final emptySurveyResponse = await getdata.getData(
        global.globalToken, "shared/questionnaire/${widget.id}");
    final filledSurveyResponse = await getdata.getData(
        global.globalToken, "shared/questionnaire/${widget.id}");

    if (filledSurveyResponse.statusCode == 200) {
      final filledSurveyMap = jsonDecode(filledSurveyResponse.body);
      print('HERE IS THE FILLED DATA: $filledSurveyMap');
      return filledSurveyMap.cast<String, dynamic>();
    } else {
      if (emptySurveyResponse.statusCode == 200) {
        try {
          final emptySurveyMap = jsonDecode(emptySurveyResponse.body);
          print('HERE IS THE EMPTY DATA: $emptySurveyMap');
          return emptySurveyMap.cast<String, dynamic>();
        } catch (e) {
          print('Error decoding JSON: $e');
          throw e; // Propagate the error to trigger the error handling below
        }
      } else {
        print('Error fetching data: ${emptySurveyResponse.statusCode}');

        // Display alert for content couldn't be retrieved
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Content could not be retrieved.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Pop the current screen
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
    return null;
  }

  @override
  void initState() {
    userDataFuture = _getSurveyQuestionData(context);
    postClass = PostClass();
    patchClass = PatchClass();
    super.initState();
  }

  List<Widget> buildQuestionWidgets(Map<String, dynamic> surveyData) {
    List<Widget> questionWidgets = [];
    for (var question in (surveyData['questions'] as List<dynamic>)) {
      if (question != null) {
        questionWidgets.add(
          Column(
            children: [
              Text(
                '${question['title']}',
                style: const TextStyle(
                  color: AppColors.purpleSchood,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  if ((question['answers'] as List).isEmpty)
                    TextFormField(
                      // Ajoutez ici les propriétés de votre TextFormField
                    )
                  else
                    for (var answer
                        in (question['answers'] as List<dynamic>))
                      CheckboxListTile(
                        title: Text(
                          '${answer['title']}    ',
                          style: const TextStyle(
                            color: AppColors.purpleSchood,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: isCheckedMap['${answer['title']}'] ?? false,
                        onChanged: (newValue) {
                          setState(() {
                            isCheckedMap['${answer['title']}'] = newValue!;
                          });
                        },
                      ),
                ],
              ),
            ],
          ),
        );
      }
    }
    return questionWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Go back to the previous page
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: AppColors.purpleSchood,
                ),
                const SizedBox(width: 8),
                H4TextApp(
                    text: "Retour", color: themeProvider.getTextColor())
              ],
            ),
          ),
        ),
        backgroundColor: themeProvider.getBackgroundColor(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: H1TextApp(
                text: "Questionnaire",
                color: themeProvider.getTextColor(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          ElevatedButton(
                            onPressed: () {
                              // Retry fetching data
                              setState(() {
                                userDataFuture =
                                    _getSurveyQuestionData(context);
                              });
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      );
                    } else if (snapshot.hasData) {
                      final surveyData = snapshot.data!;
                      return Column(
                        children: [
                          ...buildQuestionWidgets(surveyData),
                          ElevatedButton(
                            onPressed: () {
                            },
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
            ),
          ],
        ),
      ),
    );
  }
}
