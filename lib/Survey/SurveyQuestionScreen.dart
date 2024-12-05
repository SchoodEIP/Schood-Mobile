  import 'dart:convert';
  import 'package:flutter/material.dart';

  import 'package:provider/provider.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/Survey/SurveySummaryScreen.dart';
  import 'package:schood/request/patch.dart';
  import 'package:schood/request/post.dart';
  import 'package:schood/style/AppColors.dart';
  import 'package:schood/style/AppTexts.dart';
  import 'package:schood/request/get.dart';
  import '../global.dart' as global;
  import 'package:schood/main.dart';


class CheckboxResponse {
  String questionId;
  String answerText; // Le texte de l'option
  bool isChecked; // Si l'option est sélectionnée

  CheckboxResponse({
    required this.questionId,
    required this.answerText,
    required this.isChecked,
  });
}

 class Response {
  String questionId;
  String? text; // Réponse textuelle
  bool isChecked; // Indique si la réponse est sélectionnée (multiple)
  String? emoji; // Emoji sélectionné

  Response({
    required this.questionId,
    this.text,
    required this.isChecked,
    this.emoji,
  });

  // Méthode pour construire la réponse au format serveur
 Map<String, dynamic>? toAnswer() {
  if (text != null && text!.isNotEmpty) {
    return {"question": questionId, "answer": text};
  } else if (emoji != null) {
    return {"question": questionId, "answer": emoji};
  } else if (isChecked) {
    return {"question": questionId, "answer": text};
  }
  return null;
}
}
  class SurveyQuestionsScreen extends StatefulWidget {
    final String idsurvey;

    const SurveyQuestionsScreen({Key? key, required this.idsurvey}) : super(key: key);

    @override
    _SurveyQuestionScreenState createState() => _SurveyQuestionScreenState();
  }

  class _SurveyQuestionScreenState extends State<SurveyQuestionsScreen> with SingleTickerProviderStateMixin {
    Map<String, dynamic> surveyData = {};
    List<Response> responses = [];
    Map<String, TextEditingController> textControllers = {};
    Map<String, String> selectedEmojis = {};
    bool hasAnswers = false; // Indique si des réponses ont été récupérées

    Map<String, AnimationController> animationControllers = {};
    TextEditingController titleController = TextEditingController();
List<CheckboxResponse> checkboxResponses = [];
    final List<String> emojis = ["😄", "🙂", "😐", "☹️", "😡"];
    final Map<String, String> emojiValues = {
      "😄": "5",
      "🙂": "4",
      "😐": "3",
      "☹️": "2",
      "😡": "1",
    };

    @override
    void dispose() {
      animationControllers.forEach((key, controller) {
        controller.dispose();
      });
      super.dispose();
    }
_patchMyAnswers(String id) async {
  Map<String, dynamic> data = {
    "answers": responses.map((response) {
      if (response.text != null && response.text!.isNotEmpty) {
        return {
          "question": response.questionId,
          "answers": [response.text],
        };
      } else if (response.emoji != null && emojiValues.containsKey(response.emoji)) {
        return {
          "question": response.questionId,
          "answers": [emojiValues[response.emoji]!],
        };
      } else if (response.isChecked) {
        List<String> selectedAnswers = checkboxResponses
            .where((checkboxResponse) =>
                checkboxResponse.questionId == response.questionId &&
                checkboxResponse.isChecked)
            .map((checkboxResponse) => checkboxResponse.answerText)
            .toList();

        if (selectedAnswers.isNotEmpty) {
          return {
            "question": response.questionId,
            "answers": selectedAnswers,
          };
        }
      }
      return null;
    }).where((response) => response != null).toList(),
  };

  final patchData = PatchClass();
  final response = await patchData.patchData(context, data, "student/questionnaire/$id");

  if (response.statusCode == 200) {
    // Affiche une pop-up de succès
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Succès"),
          content: Text("Votre questionnaire a bien été modifié."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la pop-up


                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));                     },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  } else {
    // Affiche une pop-up d'erreur
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text("Une erreur est survenue lors de la modification."),
          actions: [
            TextButton(
              onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));              
                  },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}


_sendMySurvey(String id) async {
  Map<String, dynamic> data = {
    "answers": responses.map((response) {
      if (response.text != null && response.text!.isNotEmpty) {
        return {
          "question": response.questionId,
          "answers": [response.text],
        };
      } else if (response.emoji != null && emojiValues.containsKey(response.emoji)) {
        return {
          "question": response.questionId,
          "answers": [emojiValues[response.emoji]!],
        };
      } else if (response.isChecked) {
        List<String> selectedAnswers = checkboxResponses
            .where((checkboxResponse) =>
                checkboxResponse.questionId == response.questionId &&
                checkboxResponse.isChecked)
            .map((checkboxResponse) => checkboxResponse.answerText)
            .toList();

        if (selectedAnswers.isNotEmpty) {
          return {
            "question": response.questionId,
            "answers": selectedAnswers,
          };
        }
      }
      return null;
    }).where((response) => response != null).toList(),
  };

  final postData = PostClass();
  final response = await postData.postDataAuth(context, data, "student/questionnaire/$id");
  print(response.body);
  if (response.statusCode == 200) {
    // Affiche une pop-up de succès
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Succès"),
          content: Text("Votre questionnaire a bien été envoyé."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la pop-up

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  } else {
    // Affiche une pop-up d'erreur
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text("Une erreur est survenue lors de l'envoi."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la pop-up
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

bool _validateAnswers() {
  for (var question in surveyData['questions'] ?? []) {
    final questionId = question['_id'];
    final type = question['type'];

    // Pour les réponses textuelles
    if (type == 'text') {
      final responseIndex = responses.indexWhere((resp) => resp.questionId == questionId);
      if (responseIndex == -1 || (responses[responseIndex].text == null || responses[responseIndex].text!.isEmpty)) {
        return false;
      }
    }

    // Pour les réponses emoji
    else if (type == 'emoji') {
      if (!selectedEmojis.containsKey(questionId) || selectedEmojis[questionId]!.isEmpty) {
        return false;
      }
    }

    // Pour les réponses checkbox (multiple)
    else if (type == 'multiple') {
      final isAnswered = checkboxResponses.any((resp) => resp.questionId == questionId && resp.isChecked);
      if (!isAnswered) {
        return false;
      }
    }
  }

  return true; // Tout est complété
}


Future<void> _showIncompleteDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Empêche de fermer en cliquant à l'extérieur
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Formulaire incomplet'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Veuillez répondre à toutes les questions avant d\'envoyer le questionnaire.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme la popup
            },
          ),
        ],
      );
    },
  );
}

    Future<void> _showErrorDialog(BuildContext context, String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // Empêche de fermer la pop-up en cliquant à l'extérieur
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _showEditTitleDialog(BuildContext context) {
      titleController.text = surveyData['title'] ?? '';
      List<TextEditingController> questionControllers = [];
      List<String> questionTypes = [];
      List<List<TextEditingController>> choiceControllers = [];

      surveyData['questions']?.forEach((question) {
        questionControllers.add(TextEditingController(text: question['title']));
        questionTypes.add(question['type'] ?? 'text');
        if (question['type'] == 'multiple') {
          List<TextEditingController> choices = [];
          (question['answers'] ?? []).forEach((choice) {
            choices.add(TextEditingController(text: choice['title']));
          });
          choiceControllers.add(choices);
        } else {
          choiceControllers.add([]);
        }
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              void _addChoice(int questionIndex) {
                setState(() {
                  choiceControllers[questionIndex].add(TextEditingController());
                  surveyData['questions'][questionIndex]['answers'].add({'title': ''});
                });
              }

              void _removeChoice(int questionIndex, int choiceIndex) {
                setState(() {
                  choiceControllers[questionIndex].removeAt(choiceIndex);
                  surveyData['questions'][questionIndex]['answers'].removeAt(choiceIndex);
                });
              }

              return AlertDialog(
                title: Text('Modifier le questionnaire'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Nouveau titre'),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: List.generate(questionControllers.length, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: questionControllers[index],
                                      decoration: InputDecoration(
                                          labelText: 'Modifier question ${index + 1}'),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        surveyData['questions'].removeAt(index);
                                        questionControllers.removeAt(index);
                                        questionTypes.removeAt(index);
                                        choiceControllers.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              DropdownButton<String>(
                                value: questionTypes[index],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    questionTypes[index] = newValue!;
                                    if (newValue != 'multiple') {
                                      choiceControllers[index] = [];
                                      surveyData['questions'][index]['answers'] = [];
                                    }
                                  });
                                },
                                items: <String>['multiple', 'text', 'emoji']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              if (questionTypes[index] == 'multiple') ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      choiceControllers[index].length,
                                      (choiceIndex) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: choiceControllers[index][choiceIndex],
                                                decoration: InputDecoration(
                                                    labelText: 'Choix ${choiceIndex + 1}'),
                                                onChanged: (value) {
                                                  surveyData['questions'][index]['answers'][choiceIndex]['title'] = value;
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                _removeChoice(index, choiceIndex);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _addChoice(index);
                                      },
                                      child: Text('Ajouter un choix'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          );
                        }),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            TextEditingController newQuestionController = TextEditingController();
                            questionControllers.add(newQuestionController);
                            questionTypes.add('text');
                            choiceControllers.add([]);
                            surveyData['questions']?.add({
                              '_id': 'new_${DateTime.now().millisecondsSinceEpoch}',
                              'title': '',
                              'type': 'text',
                              'answers': [],
                            });
                          });
                        },
                        child: Text('Ajouter une question'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () async {
                      for (int i = 0; i < questionControllers.length; i++) {
                        surveyData['questions'][i]['title'] = questionControllers[i].text;
                        surveyData['questions'][i]['type'] = questionTypes[i];

                        if (questionControllers[i].text.isEmpty) {
                          await _showErrorDialog(context, 'Chaque question doit avoir un titre.');
                          return;
                        }

                        if (questionTypes[i] == 'multiple' && choiceControllers[i].length < 2) {
                          await _showErrorDialog(context, 'Les questions de type "multiple" doivent avoir au moins deux choix.');
                          return;
                        }

                        for (var choiceController in choiceControllers[i]) {
                          if (choiceController.text.isEmpty) {
                            await _showErrorDialog(context, 'Chaque choix doit avoir un titre.');
                            return;
                          }
                        }
                      }

                      _patchform(titleController.text);
                      Navigator.pop(context);
                    },
                    child: Text('Enregistrer'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  _patchform(String newTitle) async {
    final patchdata = PatchClass();
    String id = widget.idsurvey;

    var data = {
      'title': newTitle,
      'questions': surveyData['questions']?.map((question) {
        List<Map<String, dynamic>> answers = [];
        if (question['answers'] != null && question['answers'].isNotEmpty) {
          answers = question['answers'].map<Map<String, dynamic>>((answer) {
            return {
              'position': answer['position'] ?? 1,
              'title': answer['title']
            };
          }).toList();
        }

        return {
          'title': question['title'],
          'type': question['type'],
          'answers': answers,
        };
      }).toList() ?? [],
    };

    try {
      final response = await patchdata.patchData(context, data, "teacher/questionnaire/$id");

      if (response.statusCode == 200) {
        setState(() {
          surveyData['title'] = newTitle;
        });
      } else {
        String errorMessage = json.decode(response.body)['message'] ?? 'Une erreur est survenue';
        await _showErrorsDialog(context, errorMessage);
      }
    } catch (error) {
      await _showErrorsDialog(context, 'Erreur lors de la mise à jour du questionnaire: $error');
    }
  }

  Future<void> _showErrorsDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Empêche la fermeture en cliquant à l'extérieur
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
_getAnswers() async {
  final getdata = GetClass();
  final responsedata = await getdata.getData(
      global.globalToken, "student/questionnaire/${widget.idsurvey}");
  if (responsedata.statusCode == 200) {
    final data = json.decode(responsedata.body);
    final List<dynamic> answers = data['answers'] ?? [];

    setState(() {
      hasAnswers = answers.isNotEmpty; // Vérifie si des réponses existent
      for (var answer in answers) {
        final questionId = answer['question'];
        final List<dynamic> answerList = answer['answers'];

        // Réponses pour les questions multiples (checkbox)
        if (surveyData['questions']?.any((q) => q['_id'] == questionId && q['type'] == 'multiple') == true) {
          checkboxResponses.removeWhere((resp) => resp.questionId == questionId);
          for (var singleAnswer in answerList) {
            checkboxResponses.add(CheckboxResponse(
              questionId: questionId,
              answerText: singleAnswer,
              isChecked: true,
            ));
          }
          final responseIndex = responses.indexWhere((resp) => resp.questionId == questionId);
          if (responseIndex != -1) {
            responses[responseIndex].isChecked = true;
          } else {
            responses.add(Response(
              questionId: questionId,
              text: null,
              isChecked: true,
              emoji: null,
            ));
          }
        }

        // Réponses textuelles simples
        else if (surveyData['questions']?.any((q) => q['_id'] == questionId && q['type'] == 'text') == true) {
          if (answerList.isNotEmpty) {
            final responseIndex = responses.indexWhere((resp) => resp.questionId == questionId);
            if (responseIndex != -1) {
              responses[responseIndex].text = answerList.first;
              textControllers[questionId]?.text = answerList.first;
            }
          }
        }

        // Réponses emoji
        else if (surveyData['questions']?.any((q) => q['_id'] == questionId && q['type'] == 'emoji') == true) {
          final emoji = emojiValues.keys.firstWhere(
            (e) => emojiValues[e] == answerList.first,
            orElse: () => "",
          );
          if (emoji.isNotEmpty) {
            selectedEmojis[questionId] = emoji;
            final responseIndex = responses.indexWhere((resp) => resp.questionId == questionId);
            if (responseIndex != -1) {
              responses[responseIndex].emoji = emoji;
            }
          }
        }
      }
    });
  } else {
    print("Erreur lors de la récupération des réponses: ${responsedata.statusCode}");
  }
}


    _getSurveyQuestion() async {
      final getdata = GetClass();
      final responsedata = await getdata.getData(
          global.globalToken, "shared/questionnaire/${widget.idsurvey}");

      if (responsedata.statusCode == 200) {
        setState(() {
          surveyData = json.decode(responsedata.body);
          surveyData['questions']?.forEach((question) {
            if (question['answers'].isEmpty) {
              responses.add(Response(questionId: question['_id'], text: '', isChecked: false));
              textControllers[question['_id']] = TextEditingController();
            } else if (question['type'] == 'emoji') {
              responses.add(Response(questionId: question['_id'], text: null, isChecked: false, emoji: null));
              selectedEmojis[question['_id']] = "";
              animationControllers[question['_id']] = AnimationController(
                duration: const Duration(milliseconds: 200),
                vsync: this,
              );
            } else {
              question['answers'].forEach((answer) {
                responses.add(Response(questionId: answer['_id'], text: null, isChecked: false));
              });
            }
          });
        });
      } else {
        print("Erreur lors de la récupération des données: ${responsedata.statusCode}");
      }
    }

    @override
    void initState() {
      super.initState();
      _getSurveyQuestion();
      _getAnswers();
    }

    @override
    Widget build(BuildContext context) {
      final themeProvider = Provider.of<ThemeProvider>(context);
      bool isTeacher = global.role == "teacher";

      return Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.getBackgroundColor(),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
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
              if (isTeacher)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: themeProvider.getTextColor(),
                      onPressed: () {
                        _showEditTitleDialog(context);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
        backgroundColor: themeProvider.getBackgroundColor(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H1TextApp(
                  text: "Questionnaire",
                  color: themeProvider.getTextColor(),
                ),
                const SizedBox(height: 32),
                Column(
                  children: surveyData['questions']?.map<Widget>((question) {
                    TextEditingController? textController = textControllers[question['_id']];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: H3TextApp(
                            text: question['title'],
                          ),
                        ),
                        // Gestion des types de questions
                        if (question['type'] == 'text') 
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(
      controller: textController,
      style: TextStyle(color: themeProvider.getTextColor()),
      decoration: InputDecoration(
        labelText: "Réponse",
        labelStyle: TextStyle(color: themeProvider.getTextColor()),
      ),
      onChanged: (value) {
        setState(() {
          final responseIndex = responses.indexWhere((resp) => resp.questionId == question['_id']);
          if (responseIndex != -1) {
            responses[responseIndex].text = value;
          } else {
            responses.add(Response(questionId: question['_id'], text: value, isChecked: false));
          }
        });
      },
    ),
  ),

                        if (question['type'] == 'emoji')
                          Row(
                            children: emojis.map((emoji) {
                              bool isSelected = selectedEmojis[question['_id']] == emoji;
                              return GestureDetector(
 onTap: () {
  setState(() {
    selectedEmojis[question['_id']] = emoji;
    final responseIndex = responses.indexWhere((resp) => resp.questionId == question['_id']);
    if (responseIndex != -1) {
      responses[responseIndex].emoji = emoji;
    }
  });
}
,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    child: Text(
                                      emoji,
                                      style: TextStyle(
                                        fontSize: isSelected ? 32 : 24,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                       if (question['type'] == 'multiple') 
  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: question['answers'].map<Widget>((answer) {
                        return CheckboxListTile(
  title: H4TextApp(text:answer['title']),
  value: checkboxResponses.any((resp) =>
      resp.questionId == question['_id'] &&
      resp.answerText == answer['title'] &&
      resp.isChecked),
  onChanged: (bool? value) {
    setState(() {
      // Met à jour l'état de la case à cocher (checkbox)
      if (value == true) {
        // Si la case est cochée, ajoutez la réponse dans `checkboxResponses`
        checkboxResponses.add(CheckboxResponse(
          questionId: question['_id'],
          answerText: answer['title'],
          isChecked: true, // Marque la réponse comme cochée
        ));

        // Mettre à jour `isChecked` dans la liste des réponses
        int responseIndex = responses.indexWhere((resp) => resp.questionId == question['_id']);
        if (responseIndex != -1) {
          responses[responseIndex].isChecked = true;  // Marque la réponse comme sélectionnée
        } else {
          responses.add(Response(
            questionId: question['_id'],
            text: null,
            isChecked: true,  // La réponse est maintenant cochée
            emoji: null,
          ));
        }
      } else {
        // Si la case est décochée, supprimez la réponse de `checkboxResponses`
        checkboxResponses.removeWhere(
          (resp) =>
              resp.questionId == question['_id'] &&
              resp.answerText == answer['title'],
        );

        // Mettre à jour `isChecked` dans la liste des réponses
        int responseIndex = responses.indexWhere((resp) => resp.questionId == question['_id']);
        if (responseIndex != -1) {
          responses[responseIndex].isChecked = false; // Marque la réponse comme non sélectionnée
        }
      }
    });
  },
);

                      }).toList(),
                    ),

                    
                      ],
                    
                    );
                  }).toList() ?? [],
                   
                ),
  SizedBox(height: 32),
  if (global.role == "student")
  ElevatedButton(
    onPressed: () {
      if (!_validateAnswers()) {
        _showIncompleteDialog(); // Affiche la popup si le formulaire est incomplet
        return;
      }

      if (hasAnswers) {
        _patchMyAnswers(widget.idsurvey); // Appelle PATCH si des réponses existent
      } else {
        _sendMySurvey(widget.idsurvey); // Appelle POST si aucune réponse
      }
    },
    child: Text(hasAnswers ? "Modifier mon questionnaire" : "Envoyer"),
  ),

              
              ],
            ),
          ),
        ),
      );
    }
  }
