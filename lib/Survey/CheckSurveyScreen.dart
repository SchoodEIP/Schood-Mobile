import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/post.dart';  // Assurez-vous que le chemin est correct
import 'package:http/http.dart';
import 'package:schood/style/AppTexts.dart';  // Pour utiliser Response


class CheckQuestionnaireScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String surveyName;
  final String surveyDate;

  const CheckQuestionnaireScreen({
    Key? key,
    required this.questions,
    required this.surveyName,
    required this.surveyDate,
  }) : super(key: key);

  @override
  _CheckQuestionnaireScreenState createState() => _CheckQuestionnaireScreenState();
}

class _CheckQuestionnaireScreenState extends State<CheckQuestionnaireScreen> {
Future<void> _sendSurvey() async {
    final postclass = PostClass();
    final data = {
      "title": widget.surveyName,
      "date": widget.surveyDate,
      "questions": widget.questions
    };

    try {
      Response response = await postclass.postDataAuth(context, data, "teacher/questionnaire");

      if (response.statusCode == 200) {
        // Si l'envoi est un succès, affichez un message
 Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Questionnaire envoyé avec succès')),
        );
      } else {
        // Si l'envoi échoue, affichez un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous avez déjà publier un questionnaire')),
        );
      }
    } catch (e) {
      // Gérer toute erreur potentielle lors de la requête
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
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
                color: Colors.purple,
              ),
              const SizedBox(width: 8),
              Text("Retour", style: TextStyle(color: themeProvider.getTextColor())),
            ],
          ),
        ),
      ),
      backgroundColor: themeProvider.getBackgroundColor(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.surveyName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.getTextColor(),
                ),
              ),
              Text(
                'Date de parution: ${widget.surveyDate}',
                style: TextStyle(
                  fontSize: 16,
                  color: themeProvider.getTextColor(),
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: widget.questions.map<Widget>((question) {
                  final String questionTitle = question['title'] ?? 'Question non spécifiée';
                  final String questionType = question['type'] ?? 'texte';
                  final List<dynamic> choices = question['answers'] ?? []; // Utiliser 'answers' pour les choix

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: H4TextApp(
                          text:questionTitle,
                         
                        ),
                      ),
                      if (questionType == 'emoji')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ["😄", "🙂", "😐", "☹️", "😡"].map((emoji) {
                            return Column(
                              children: [
                                Text(
                                  emoji,
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      if (questionType == 'text')
                       Center(
                          child: Text(
                            'Réponse texte attendue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      if (questionType == 'multiple' && choices.isNotEmpty)
                        Column(
                          children: List.generate(
                            choices.length,
                            (choiceIndex) {
                              final choice = choices[choiceIndex];
                              return CheckboxListTile(
                                title: H4TextApp(
                                  text:choice['title'] ?? 'Choix non spécifié',
                                  
                                ),
                                value: false, // Cases décochées par défaut
                                onChanged: (bool? value) {},
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 40.0),
              Center(
                child: ElevatedButton(
                  onPressed: _sendSurvey,
                  child: const Text('Envoyer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

