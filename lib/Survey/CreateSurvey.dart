import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:schood/Survey/CheckSurveyScreen.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart'; // Assurez-vous que le chemin est correct
import 'package:schood/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:schood/utils/TextFieldForm.dart'; // Import pour la localisation

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Créer un Questionnaire',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr', ''), // Français
      ],
      home: CreateSurveyScreen(),
    );
  }
}

class CreateSurveyScreen extends StatefulWidget {
  const CreateSurveyScreen({Key? key}) : super(key: key);

  @override
  _CreateSurveyScreenState createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  List<Map<String, dynamic>> questions = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String selectedClass = "Toute";
  String? selectedClassId;
  List<Map<String, dynamic>> classes = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    classes = global.classesList;
  }

  void _addQuestion() {
    setState(() {
      questions.add({
        'question': '',
        'type': 'texte',
        'choices': [],
      });
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      questions.removeAt(index); // Supprimer la question par index
    });
  }

  void _updateQuestion(int index, String value) {
    setState(() {
      questions[index]['question'] = value;
    });
  }

  void _updateQuestionType(int index, String value) {
    setState(() {
      questions[index]['type'] = value;
      if (value != 'choix') {
        questions[index]['choices'] = []; // Réinitialiser les choix si ce n'est pas un type "choix"
      }
    });
  }

  void _addChoice(int questionIndex) {
    setState(() {
      questions[questionIndex]['choices'].add('');
    });
  }

  void _updateChoice(int questionIndex, int choiceIndex, String value) {
    setState(() {
      questions[questionIndex]['choices'][choiceIndex] = value;
    });
  }

  bool _isDateValid() {
    if (_selectedDate == null) return false;
    return _selectedDate!.isAfter(DateTime.now().subtract(Duration(days: 1)));
  }

  void _validateSurvey() {
    if (_nameController.text.isEmpty) {
      _showErrorDialog('Le titre du questionnaire est obligatoire.');
      return;
    }

    if (!_isDateValid()) {
      _showErrorDialog('La date ne peut pas être antérieure à aujourd\'hui.');
      return;
    }

    if (questions.isEmpty) {
      _showErrorDialog('Vous devez ajouter au moins une question.');
      return;
    }

    for (var question in questions) {
      if (question['question']?.isEmpty ?? true) {
        _showErrorDialog('Chaque question doit avoir un titre.');
        return;
      }

      if (question['type'] == 'choix' && (question['choices']?.length ?? 0) < 2) {
        _showErrorDialog('Les questions de type "choix" doivent avoir au moins deux choix.');
        return;
      }

      for (var choice in question['choices'] ?? []) {
        if (choice.isEmpty) {
          _showErrorDialog('Chaque choix doit avoir un titre.');
          return;
        }
      }
    }

    // Transformation des questions pour respecter le format demandé par l'API
    List<Map<String, dynamic>> formattedQuestions = questions.map((question) {
      Map<String, dynamic> formattedQuestion = {
        'title': question['question'], // On remplace 'question' par 'title'
        'type': _mapQuestionType(question['type']), // On mappe le type correctement
      };

      // Si la question est de type "choix", on ajoute les réponses avec position et titre
      if (question['type'] == 'choix') {
        formattedQuestion['answers'] = List.generate(question['choices'].length, (index) {
          return {
            'position': index + 1, // On commence la position à 1
            'title': question['choices'][index], // On enregistre chaque choix comme un 'title'
          };
        });
      }

      return formattedQuestion;
    }).toList();
  ;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckQuestionnaireScreen(
          questions: formattedQuestions, // On envoie les questions dans le bon format
          surveyName: _nameController.text,
          surveyDate: _selectedDate != null ? _selectedDate.toString().split(' ')[0] : '',
        ),
      ),
    );
  }

  String _mapQuestionType(String type) {
    switch (type) {
      case 'choix':
        return 'multiple'; // On mappe "choix" à "multiple"
      case 'texte':
        return 'text'; // On mappe "texte" à "text"
      case 'emoji':
        return 'emoji'; // "emoji" reste "emoji"
      default:
        return 'text'; // On met "text" par défaut si jamais
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      locale: Locale('fr'), // Définir la langue du calendrier à français
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = "${DateFormat('yyyy-MM-dd').format(pickedDate)}";
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
 TextFormField(
                          controller: _nameController,
                          
                          style: TextStyle(color: AppColors.backgroundDarkmode),
                          decoration: InputDecoration(
                            hintText: 'Nom du questionnaire',
                            hintStyle: TextStyle(color: themeProvider.backgroundDarkMode),
                            fillColor: AppColors.pinkSchood, // Fond rose
                            filled: true, // Appliquer la couleur de fond
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure par défaut
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure lorsqu'il est désactivé
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure lorsqu'il est activé
                            ),
                          ),
                        ),
                                                SizedBox(height: 20),
             TextFormField(
                          controller: _dateController,
 
                          style: TextStyle(color: AppColors.backgroundDarkmode),
                                        readOnly: true,
              onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            hintText: 'Date de parution',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                              ),
                     

                            hintStyle: TextStyle(color: themeProvider.backgroundDarkMode),
                            fillColor: AppColors.pinkSchood, // Fond rose
                            filled: true, // Appliquer la couleur de fond
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure par défaut
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure lorsqu'il est désactivé
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure lorsqu'il est activé
                            ),
                          ),
                        ),

            SizedBox(height: 20),
            H4TextApp(text: "Classe"),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: DropdownButton<String>(
                  value: selectedClass,
                  iconEnabledColor: themeProvider.getTextColor(),
                  dropdownColor: themeProvider.getBackgroundColor(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedClass = newValue!;
                      selectedClassId = classes.firstWhere((classe) => classe['name'] == newValue, orElse: () => {'_id': 'all'})['_id'];
                    });
                  },
                  items: ['Toute', ...classes.map((classe) => classe['name'] as String)]
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: H4TextApp(text: value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Ajouter une question'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Question ${index + 1}'),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  _removeQuestion(index); // Suppression de la question
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                           onChanged: (value) {
                              _updateQuestion(index, value);
                            },
                          style: TextStyle(color: AppColors.backgroundDarkmode),
                          decoration: InputDecoration(
                            hintText: 'Question',
                            hintStyle: TextStyle(color: themeProvider.backgroundDarkMode),
                            fillColor: AppColors.pinkSchood, // Fond rose
                            filled: true, // Appliquer la couleur de fond
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure par défaut
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure lorsqu'il est désactivé
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure lorsqu'il est activé
                            ),
                          ),
                        ),
                          /*TextField(
                            decoration: InputDecoration(
                              labelText: 'Question',
                            ),
                            onChanged: (value) {
                              _updateQuestion(index, value);
                            },
                            // Pas de TextEditingController ici
                          ),*/
                          DropdownButton<String>(
                            value: questions[index]['type'],
                            onChanged: (value) {
                              if (value != null) {
                                _updateQuestionType(index, value);
                              }
                            },
                            items: [
                              DropdownMenuItem(
                                value: 'texte',
                                child: Text('Texte'),
                              ),
                              DropdownMenuItem(
                                value: 'choix',
                                child: Text('Choix'),
                              ),
                              DropdownMenuItem(
                                value: 'emoji',
                                child: Text('Smiley'),
                              ),
                            ],
                          ),
                          if (questions[index]['type'] == 'choix') ...[
                            Column(
                              
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(
                                  questions[index]['choices'].length,
                                  (choiceIndex) {
                                    
                                    return TextFormField(
                           onChanged: (value) {
                                        _updateChoice(index, choiceIndex, value);
                                      },
                          style: TextStyle(color: AppColors.backgroundDarkmode),
                          decoration: InputDecoration(
                            hintText: 'Choix${choiceIndex +1}',
                            hintStyle: TextStyle(color: themeProvider.backgroundDarkMode),
                            fillColor: AppColors.pinkSchood, // Fond rose
                            filled: true, // Appliquer la couleur de fond
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure par défaut
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure lorsqu'il est désactivé
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bordures arrondies
                              borderSide: BorderSide.none, // Pas de bordure lorsqu'il est activé
                            ),
                          ),
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
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _validateSurvey,
              child: Text('Valider le questionnaire'),
            ),
          ],
        ),
      ),
    );
  }
}
