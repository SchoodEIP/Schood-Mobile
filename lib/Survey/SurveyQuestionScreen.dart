import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  Map<String, bool> isCheckedMap = {};
  Map<String, dynamic> surveyData = {};
  List<TextEditingController> textControllers = [];
  List<dynamic> answers = [];

  _sendform() async {
    final postdata = PostClass();
    String id = widget.id;

    var data = {'answers': answers};
    print(data);
    /*try{
    Response response = await postdata.postDataAuth(context, data,"student/questionnaire/$id");
    }catch(error){
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Une erreur est survenue'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Veuillez reessayer plus tard'),
              ),
            ],
          );
        });

    }*/
  }

  _getSurveyQuestion() async {
    final getdata = GetClass();
    Response response = await getdata.getData(
        global.globalToken, "shared/questionnaire/${widget.id}");

    if (response.statusCode == 200) {
      // Si la réponse est réussie, décoder le JSON
      setState(() {
        surveyData = json.decode(response.body);
      });
    } else {
      // Gérer les erreurs ici
      print("Erreur lors de la récupération des données: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    _getSurveyQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
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
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: surveyData['questions']?.map<Widget>((question) {
                TextEditingController textController = TextEditingController();
                textControllers.add(textController);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        question['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (question['answers'].isEmpty)
                      TextFormField(
                        onSaved:(String? value) {

                        },
                        controller: textController,
                        onChanged: (value) {
      setState(() {
        int index = textControllers.indexWhere((controller) => controller == textController);
        answers[index] = {
          'question_id': surveyData['questions'][index]['_id'],
          'answer': value,
        };
      });
                        },
                        decoration: InputDecoration(
                          hintText: 'Réponse...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (question['answers'].isNotEmpty)
                      Column(
                        children: question['answers'].map<Widget>((answer) {
                          return CheckboxListTile(
                            title: Text(answer['title']),
                            value: isCheckedMap[answer['_id']] ?? false,
                            onChanged: (value) {
                              setState(() {
                                isCheckedMap[answer['_id']] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    SizedBox(height: 16),
                  ],
                );
              }).toList() ?? [],
            ),
          ),
        Center(child:ElevatedButton(onPressed: _sendform, child: Text("Envoyer")))
        ],
      ),
    );
  }
}
