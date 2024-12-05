import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class SurveySeeAnswersScreen extends StatefulWidget {
  const SurveySeeAnswersScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _SurveySeeAnswersScreenState createState() => _SurveySeeAnswersScreenState();
}

class _SurveySeeAnswersScreenState extends State<SurveySeeAnswersScreen> {
  List<Map<String, dynamic>> users = [];
  String? selectedStudentId;
  Map<String, dynamic> answersData = {};
  Map<String, dynamic> questionnaireData = {};

  final List<String> emojis = ["😄", "🙂", "😐", "☹️", "😡"];
  final Map<String, String> emojiValues = {
    "😄": "5",
    "🙂": "4",
    "😐": "3",
    "☹️": "2",
    "😡": "1",
  };

  @override
  void initState() {
    super.initState();
    getuser();
  }

  // Récupère la liste des utilisateurs
  getuser() async {
    try {
      final getData = GetClass();
      final id = widget.id;
      final response = await getData.getData(global.globalToken, "teacher/questionnaire/$id/students");
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      setState(() {
        users = List<Map<String, dynamic>>.from(responseData['users'].map((user) {
          return {
            '_id': user['_id'],
            'firstname': user['firstname'],
            'lastname': user['lastname'],
          };
        }));
      });
    } catch (e) {
      print("Erreur lors de la récupération des utilisateurs: $e");
    }
  }

  // Récupère les réponses d'un étudiant
  getanswers(String studentId) async {
    try {
      final getData = GetClass();
      final id = widget.id;

      // Récupère les réponses pour l'étudiant spécifié
      final response = await getData.getData(global.globalToken, "teacher/questionnaire/$id/answers/$studentId");
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extraire l'ID du questionnaire de la première réponse
      final questionnaireId = responseData['questionnaire'];

      // Récupère les détails du questionnaire en utilisant l'ID extrait
      final response2 = await getData.getData(global.globalToken, "shared/questionnaire/$questionnaireId");
      final Map<String, dynamic> questionnaireData = jsonDecode(response2.body);
      print(response2.body);
      setState(() {
        answersData = responseData;  // Stocke toutes les réponses
        this.questionnaireData = questionnaireData; // Stocke les données du questionnaire
      });
    } catch (e) { 
      print("Erreur lors de la récupération des réponses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

   return Scaffold(
  backgroundColor: themeProvider.getBackgroundColor(),
  appBar: AppBar(
    backgroundColor: themeProvider.getBackgroundColor(),
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
            text: "Retour",
            color: themeProvider.getTextColor(),
          ),
        ],
      ),
    ),
  ),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            H2TextApp(
              text: "Réponse",
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Dropdown pour sélectionner l'utilisateur
        DropdownButton<String>(
          dropdownColor: themeProvider.getBackgroundColor(),
          hint: Text("Sélectionnez un étudiant", style: TextStyle(color: themeProvider.getTextColor() ),),
          value: selectedStudentId,
          onChanged: (String? newValue) {
            setState(() {
              selectedStudentId = newValue;
            });

            // Appeler la méthode getanswers avec l'ID de l'étudiant sélectionné
            if (newValue != null) {
              getanswers(newValue);
            }
          },
          items: users.map<DropdownMenuItem<String>>((user) {
            return DropdownMenuItem<String>(
              value: user['_id'],
              child: Text("${user['firstname']} ${user['lastname']}", style:TextStyle(                        color: themeProvider.getTextColor(),),),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Vérification si aucune classe ou aucune réponse n'est disponible
        if (selectedStudentId == null)
          Center(
            child: H3TextApp(text:
              "Aucun étudiant sélectionnée.",
             
            ),
          )
        else if (answersData.isEmpty || questionnaireData.isEmpty)
          Center(
            child: Text(
              "Aucune réponse disponible pour ce questionnaire.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.getTextColor(),
              ),
            ),
          )
        else
          // Affichage des réponses récupérées
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(questionnaireData['questions'].length, (index) {
              final question = questionnaireData['questions'][index];
              final questionId = question['_id'];
              final questionTitle = question['title'];
              final questionType = question['type'];
              final options = question['answers'] ?? [];

              // Trouver la réponse correspondante
              final answer = answersData['answers'].firstWhere(
                (ans) => ans['question'] == questionId,
                orElse: () => {'answers': []},
              );

              Widget questionWidget;
              if (questionType == 'emoji') {
                questionWidget = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: emojis.map((emoji) {
                    bool isSelected = emojiValues[emoji] == answer['answers'].first;
                    return Column(
                      children: [
                        H1TextApp(text: emoji),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                );
              } else if (questionType == 'text') {
                questionWidget = Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    answer['answers'].first,
                    style: TextStyle(
                      color: themeProvider.getTextColor(),
                    ),
                  ),
                );
              } else if (questionType == 'multiple') {
                questionWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: options.map<Widget>((option) {
                    bool isChecked = answer['answers'].contains(option['title']);
                    return CheckboxListTile(
                      title: Text(option['title'],style: TextStyle(                        color: themeProvider.getTextColor(),),),
                      value: isChecked,
                      onChanged: null, // Désactiver l'interaction
                      controlAffinity: ListTileControlAffinity.leading, // Optionnel
                    );
                  }).toList(),
                );
              } else {
                questionWidget = Container(); // Cas par défaut si aucun type n'est trouvé
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.getTextColor(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    questionWidget,
                  ],
                ),
              );
            }),
          ),
      ],
    ),
  ),
);
  }
}