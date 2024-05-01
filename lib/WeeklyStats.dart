import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'global.dart' as global;

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int daydatebefore = 7;
  String selectedOption = "Semaine";
  Map<String, Map<String, dynamic>> moodData = {};
    Map<String, Map<String, dynamic>> drawmoodData = {};

  int averagePercentage = 0;
  List<String> arraymood= [];
_setmoodweekly() {
 arraymood= [];


  DateTime currentDate = DateTime.now();

  // Boucle pour les semaines 1 à 5
  for (int i = 1; i <= 5; i++) {
    // Calcul des dates de début et de fin de semaine
    DateTime endDate = currentDate.subtract(Duration(days: (i - 1) * 7)); // Date de fin de la semaine
    DateTime startDate = endDate.subtract(Duration(days: 6)); // Date de début de la semaine

    var dataForWeek = drawmoodData.entries.where((entry) {
      DateTime entryDate = DateTime.parse(entry.key);
      return entryDate.isAfter(startDate) && entryDate.isBefore(endDate);
    });

    double totalAverage = 0.0;
    int count = 0;
    for (var entry in dataForWeek) {
      var average = entry.value['average']; // Extraire la valeur de 'average'
      if (average != null && average is num) { // Vérifier si la valeur n'est pas nulle et est du bon type
        totalAverage += (average as num).toDouble(); // Conversion en double avant l'addition
        count++;
      }
    }

    String averagemood = "Pas de donnée"; // Déclaration de averagemood en dehors de la condition if

    // Vérifier s'il y a des données pour la semaine actuelle avant de calculer la moyenne
    if (count > 0) {
      var average = totalAverage / count;
      if (average >= 0 && average < 1) {
        averagemood = "Très mauvais";
      } else if (average >= 1 && average < 2) {
        averagemood = "Mauvais";
      }else if (average >= 2 && average < 3) {
        averagemood = "Moyen";
      }  else if (average >= 3 && average < 4) {
        averagemood = "Bon";
      } else if (average >= 4) {
        averagemood = "Excellent";
      }
    }

    if (averagemood == "Pas de donnée") {
      arraymood.add("Il y a $i Semaine: Pas de donnée"); // Ajouter un message si aucune donnée n'est disponible
    } else {
      arraymood.add("Il y a $i Semaine: $averagemood"); // Ajouter la qualité de l'humeur à arraymood
    }
  }
  // Ajoutez ici la logique pour les semaines suivantes en fonction de vos besoins
}



  _getmood(BuildContext context, datebefore) async {
    final postdata = PostClass();
    DateTime currentDate = DateTime.now();
    var data = {
      "fromDate": datebefore.toIso8601String(),
      "toDate": currentDate.toIso8601String()
    };
    Response response = await postdata.postDataAuth(context, data, "student/statistics/moods");
    Map<String, dynamic> responseData = jsonDecode(response.body);

    DateTime datebeforedraw = currentDate.subtract(Duration(days: 35));
    var data2 = {"fromDate":datebeforedraw.toIso8601String(), "toDate": currentDate.toIso8601String()};
    Response response2 = await postdata.postDataAuth(context, data2, "student/statistics/moods");
    Map<String, dynamic> responseData2 = jsonDecode(response2.body);
    
    responseData.forEach((key, value) {
      if (key != 'averagePercentage') {
        moodData[key] = {
          'moods': value['moods'],
          'average': value['average']
        };
      }
    });
        responseData2.forEach((key, value) {
      if (key != 'averagePercentage') {
        drawmoodData[key] = {
          'moods': value['moods'],
          'average': value['average']
        };
      }
    });
  _setmoodweekly(); 
    //averagePercentage = responseData['averagePercentage'] ?? 0;
if (daydatebefore == 365) {
  Map<String, Map<String, dynamic>> newData = {};
  moodData.forEach((key, value) {
    DateTime date = DateTime.parse(key);
    String monthName = '';

    switch (date.month) {
      case 1:
        monthName = 'January';
        break;
      case 2:
        monthName = 'February';
        break;
      case 3:
        monthName = 'March';
        break;
      case 4:
        monthName = 'April';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'June';
        break;
      case 7:
        monthName = 'July';
        break;
      case 8:
        monthName = 'August';
        break;
      case 9:
        monthName = 'September';
        break;
      case 10:
        monthName = 'October';
        break;
      case 11:
        monthName = 'November';
        break;
      case 12:
        monthName = 'December';
        break;
    }

    if (!newData.containsKey(monthName)) {
      newData[monthName] = value;
    } else {
      // Si des données existent déjà pour ce mois, fusionnez-les
      newData[monthName]!['moods'].addAll(value['moods']);
      newData[monthName]!['average'] = (newData[monthName]!['average'] + value['average']);
    }
  });

  moodData = newData;

  moodData.forEach((month, data) {
    int totalMoods = data['moods'].length;
    double average = data['average'] / totalMoods;
    data['average'] = average; // Mettre à jour la valeur de 'average' dans la map

  });
}

  }

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    DateTime datebefore = currentDate.subtract(Duration(days: daydatebefore));
    //selectedOption = 'Année';
    _getmood(context, datebefore);
    _setmoodweekly(); 
    moodData;
  }

  @override
  Widget build(BuildContext context) {
      final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
           InkWell(
            onTap: (){ Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
            },
            child: const Padding(
              padding:  EdgeInsets.all(8),
              child: Icon(Icons.notifications_none,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: const Padding(
              padding:  EdgeInsets.all(8),
              child: Icon(Icons.account_circle,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      ),
      backgroundColor: themeProvider.getBackgroundColor(),
      body: SingleChildScrollView(
        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: H1TextApp(
              text: "Statistiques hebdomadaires",
              color: themeProvider.getTextColor(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MyDropdown(

            onChanged: (String value) {
              setState(() {
  selectedOption = value;
  if (selectedOption == 'Année') {
    daydatebefore = 365;
  } else {
    daydatebefore = 7;
  }
  DateTime currentDate = DateTime.now();
  DateTime datebefore = currentDate.subtract(Duration(days: daydatebefore));
  moodData = {}; // Réinitialiser moodData
  setState(() {

      _getmood(context, datebefore);
  });


});
}),
          const SizedBox(height: 20),
           Padding(padding:EdgeInsets.only(left: 16, right: 16),  child:Column(            crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,children: [   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              if (selectedOption == 'Semaine')
                ...[

                  StatsGraph(name: "L", value: moodData['Monday']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "M", value: moodData['Tuesday']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "M", value: moodData['Wednesday']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "J", value: moodData['Thursday']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "V", value: moodData['Friday']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "S", value: moodData['Saturday']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "D", value: moodData['Sunday']?['average']?.toDouble() ?? 0),
                ],
                if (selectedOption == 'Année')
                ...[
                  StatsGraph(name: "J", value: moodData['January']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "F", value: moodData['February']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "M", value: moodData['March']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "A", value: moodData['April']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "M", value: moodData['May']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "J", value: moodData['June']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "J", value: moodData['July']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "A", value: moodData['August']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "S", value: moodData['September']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "O", value: moodData['October']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "N", value: moodData['November']?['average']?.toDouble() ?? 0),
                  StatsGraph(name: "D", value: moodData['December']?['average']?.toDouble() ?? 0),
                ],
                
            ],


          ), const Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 15), 
            
            Text('😡'),
            SizedBox(height: 15), // Espace entre les valeurs
            Text('☹️'),
            SizedBox(height: 15),
            Text('😐'),
            SizedBox(height: 15),
            Text('🙂'),
            SizedBox(height: 15),
            Text('😄'),
            SizedBox(height: 30), // Espace supplémentaire en bas pour l'axe
          ],
        ),
          ])),
          const Center(child: H2TextApp(
              text: "Semaines passées",
              color: AppColors.backgroundDarkmode)),
                         SizedBox(height: 20,),
           Center(child:H4TextApp(text: arraymood.length > 0 ? arraymood[0] : "Semaine 1: Pas de donnée")),
           SizedBox(height: 10,),
Center(child:H4TextApp(text: arraymood.length > 1 ? arraymood[1] : "Semaine 2: Pas de donnée")),
           SizedBox(height: 10,),
Center(child:H4TextApp(text: arraymood.length > 2 ? arraymood[2] : "Semaine 3: Pas de donnée")),
           SizedBox(height: 10,),
Center(child:H4TextApp(text: arraymood.length > 3 ? arraymood[3] : "Semaine 4: Pas de donnée")),
           SizedBox(height: 10,),
Center(child:H4TextApp(text: arraymood.length > 4 ? arraymood[4] : "Semaine 5: Pas de donnée")),
           SizedBox(height: 30,),

        ],
      )),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 2,
      ),
    );
  }
}


class StatsGraph extends StatefulWidget {
  final String name;
  final double value;
  StatsGraph({required this.name, required this.value});
  @override
  _StatsGraphState createState() => _StatsGraphState();
}

class _StatsGraphState extends State<StatsGraph> {
  @override
  void didUpdateWidget(StatsGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Vérifiez si les données ont changé et appelez setState si nécessaire
    if (widget.name != oldWidget.name || widget.value != oldWidget.value) {
      setState(() {print(widget.name);
      print(widget.value);});
    }
  }
  Widget build(BuildContext context) {
   Color color;
      if (widget.value < 1) {
    color = Colors.red;
  } else if (widget.value >= 1 && widget.value < 2) {
    color = Colors.orange;
  } else if (widget.value >= 2 && widget.value < 3) {
    color = Colors.yellow;
  } else if (widget.value >= 3 && widget.value < 4) {
    color = Colors.lightGreen;
  } else {
    color = Colors.green;
  }


    return Column(
      children: [
        Container(
          width: 10,
          height: 188, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, 170), 
                child: Column(
                  children: [
                    H4TextApp(text: widget.name),
                    
                    Column(
    children: [
      Container(
        width: 10,
        height: (widget.value * 40) + 10, // Hauteur ajustée en fonction de la valeur
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0), // Arrondi en bas à gauche
            bottomRight: Radius.circular(10.0), // Arrondi en bas à droite
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Votre contenu ici
          ],
        ),
      ),
    ],
  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class MyDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const MyDropdown({Key? key, required this.onChanged }) : super(key: key);

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String selectedOption = 'Semaine';

  @override
  Widget build(BuildContext context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
    return Center(
      child: DropdownButton<String>(
        value: selectedOption,
        iconEnabledColor: themeProvider.getTextColor(),
dropdownColor: themeProvider.getBackgroundColor(),
        onChanged: (String? newValue) {
          setState(() {
            selectedOption = newValue!;
            widget.onChanged(selectedOption);
          });
        },
        items: <String>['Semaine',  'Année'].map((String value) {
          return DropdownMenuItem<String>(
            
            value: value,
            child: H4TextApp(text: value,),
          );
        }).toList(),
      ),
    );
  }
}
