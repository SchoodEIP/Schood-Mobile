import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class SeeTeacherFeelingScreen extends StatefulWidget {
  const SeeTeacherFeelingScreen({Key? key}) : super(key: key);

  @override
  _SeeTeacherFeelingScreenState createState() => _SeeTeacherFeelingScreenState();
}

class _SeeTeacherFeelingScreenState extends State<SeeTeacherFeelingScreen> {
  List<Map<String, dynamic>> feelings = [];
  List<Map<String, dynamic>> classes = [];
  String? selectedClass; // Classe sélectionnée
  String? selectedClassId; // ID de la classe sélectionnée

  // Mappage des valeurs emoji
  final Map<String, String> emojiValues = {
    "😄": "4",
    "🙂": "3",
    "😐": "2",
    "☹️": "1",
    "😡": "0",
  };

  String? selectedEmoji; // Emoji sélectionné pour l'affichage

  @override
  void initState() {
    super.initState();
    classes = global.classesList;

    if (classes.isNotEmpty) {
      // Initialiser avec la première classe de la liste
      selectedClass = classes[0]['name'];
      selectedClassId = classes[0]['_id'];
      getFeeling(selectedClassId); // Récupérer les ressentis pour cette classe
    }
  }

  getFeeling(id) async {
    final getData = GetClass();
    final response = await getData.getData(global.globalToken, "teacher/dailyMood/$id");
    final Map<String, dynamic> data = jsonDecode(response.body);
print(data);
    // Récupérer le mood et mapper avec l'emoji correspondant
    final moodValue = data['mood'].toString(); // Convertir en String
    selectedEmoji = emojiValues.keys.firstWhere(
      (emoji) => emojiValues[emoji] == moodValue, 
      orElse: () => "😐" // Valeur par défaut si le mood n'est pas trouvé
    );

    setState(() {
      feelings = [data]; // Met à jour les feelings avec les données reçues
    });
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
                  text: "Les ressentis de la classe $selectedClass",
                  color: AppColors.purpleSchood,
                ),
              ],
            ),
            SizedBox(height: 16),


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
                      selectedClassId = classes.firstWhere(
                        (classe) => classe['name'] == newValue, 
                        orElse: () => {'_id': 'all'}
                      )['_id'];
                      // Récupérer les ressentis basés sur la classe sélectionnée
                      getFeeling(selectedClassId);
                    });
                  },
                  items: classes.map((classe) => classe['name'] as String)
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: H4TextApp(text: value),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Affichage du smiley correspondant au mood
            if (selectedEmoji != null)
              Center(
                child: Text(
                  selectedEmoji!, // Affiche le smiley sélectionné
                  style: TextStyle(fontSize: 100), // Taille du smiley
                ),
              ),

            SizedBox(height: 16),

            // Affichage des ressentis en lignes de 2
            
          ]
      ),
    ));
  }
}
