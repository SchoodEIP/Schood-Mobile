import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/graphstats.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:intl/intl.dart'; 
import 'global.dart' as global;

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int daydatebefore = 7;
  String selectedOption = "Semaine";
  String selectedClass = "Toute";
  String? selectedClassId;
  Map<String, Map<String, dynamic>> moodData = {};
  Map<String, Map<String, dynamic>> drawmoodData = {};
  List<Map<String, dynamic>> classes = []; 
  int averagePercentage = 0;
  List<String> arraymood= [];

  _setmoodweekly() {
    arraymood = [];
    DateTime currentDate = DateTime.now();

    for (int i = 1; i <= 5; i++) {
      DateTime endDate = currentDate.subtract(Duration(days: (i - 1) * 7));
      DateTime startDate = endDate.subtract(Duration(days: 6));

      var dataForWeek = drawmoodData.entries.where((entry) {
        DateTime entryDate = DateTime.parse(entry.key);
        return entryDate.isAfter(startDate) && entryDate.isBefore(endDate);
      });

      double totalAverage = 0.0;
      int count = 0;
      for (var entry in dataForWeek) {
        var average = entry.value['average'];
        if (average != null && average is num) {
          totalAverage += (average as num).toDouble();
          count++;
        }
      }

      String averagemood = "Pas de données";
      if (count > 0) {
        var average = totalAverage / count;

        if (average >= 1 && average < 2) {
          averagemood = "Très mauvais";
        } else if (average >= 2 && average < 3) {
          averagemood = "Mauvais";
        } else if (average >= 3 && average < 4) {
          averagemood = "Moyen";
        } else if (average >= 4.0 && average < 5.0) {
          averagemood = "Bon";
        } else if (average >= 5.0) {
          averagemood = "Excellent";
        }
      }

      if (averagemood == "Pas de données") {
        arraymood.add("Il y a $i Semaine: Pas de données");
      } else {
        arraymood.add("Il y a $i Semaine: $averagemood");
      }
    }
  }

  _onDropdownChanged(String value) {
    setState(() {
      selectedOption = value;
      if (selectedOption == 'Année') {
        daydatebefore = 365;
      } else {
        daydatebefore = 7;
      }
      DateTime currentDate = DateTime.now();
      DateTime datebefore = currentDate.subtract(Duration(days: daydatebefore));
      moodData = {};
      if (global.role == "student") {
        _getmood(context, datebefore);
      } else {
        _getstudentmood(context, datebefore, selectedClassId ?? 'all');
      }
    });
  }

  _onClassDropdownChanged(String classId) {
    setState(() {
      selectedClassId = classId;
      DateTime currentDate = DateTime.now();
      DateTime datebefore = currentDate.subtract(Duration(days: daydatebefore));
      moodData = {};
      if (global.role != "student") {
        _getstudentmood(context, datebefore, classId);
      }
    });
  }

  _getstudentmood(BuildContext context, DateTime datebefore, String classId) async {
    final postdata = PostClass();
    DateTime currentDate = DateTime.now();
    DateTime datebeforedraw = currentDate.subtract(Duration(days: 35));
    var data = {
      "fromDate": datebefore.toIso8601String(),
      "toDate": currentDate.toIso8601String(),
      "classFilter": classId == "all" ? "all" : classId
    };
    final response = await postdata.postDataAuth(context, data, "shared/statistics/dailyMoods");
    var data2 = {"fromDate": datebeforedraw.toIso8601String(), "toDate": currentDate.toIso8601String()};
    final response2 = await postdata.postDataAuth(context, data, "shared/statistics/dailyMoods");
    Map<String, dynamic> responseData2 = jsonDecode(response2.body);
    Map<String, dynamic> responseData = jsonDecode(response.body);

    if (daydatebefore != 365) {
      responseData.forEach((key, value) {
        if (key != 'averagePercentage') {
          DateTime date = DateTime.parse(key);
          String dayOfWeek = DateFormat.E().format(date);
          moodData[dayOfWeek] = {
            'moods': value['moods'],
            'average': (value['average'] as num).toDouble()
          };
        }
      });
    } else {
      Map<String, Map<String, dynamic>> newData = {};
      responseData.forEach((key, value) {
        if (key != 'averagePercentage') {
          DateTime date = DateTime.parse(key);
          String monthName = DateFormat.MMMM().format(date);
          newData.putIfAbsent(monthName, () => {'moods': [], 'average': 0});
          newData[monthName]!['moods'].addAll(value['moods']);
          newData[monthName]!['average'] += (value['average'] as num).toDouble();
        }
      });

      newData.forEach((month, data) {
        int totalMoods = data['moods'].length;
        double average = totalMoods > 0 ? data['average'] / totalMoods : 0;
        data['average'] = average;
      });

      moodData = newData;
    }
    await _setmoodweekly();
    setState(() {});
  }

  _getmood(BuildContext context, DateTime datebefore) async {
    final postdata = PostClass();
    DateTime currentDate = DateTime.now();

    var data = {
      "fromDate": datebefore.toIso8601String(),
      "toDate": currentDate.toIso8601String()
    };
    Response response = await postdata.postDataAuth(context, data, "student/statistics/moods");
    Map<String, dynamic> responseData = jsonDecode(response.body);

    DateTime datebeforedraw = currentDate.subtract(Duration(days: 35));
    var data2 = {
      "fromDate": datebeforedraw.toIso8601String(),
      "toDate": currentDate.toIso8601String()
    };
    Response response2 = await postdata.postDataAuth(context, data2, "student/statistics/moods");
    Map<String, dynamic> responseData2 = jsonDecode(response2.body);

    if (daydatebefore != 365) {
      responseData.forEach((key, value) {
        if (key != 'averagePercentage') {
          DateTime date = DateTime.parse(key);
          String dayOfWeek = DateFormat.E().format(date);
          moodData[dayOfWeek] = {
            'moods': value['moods'],
            'average': (value['average'] as num).toDouble()
          };
        }
      });
    } else {
      Map<String, Map<String, dynamic>> newData = {};
      responseData.forEach((key, value) {
        if (key != 'averagePercentage') {
          DateTime date = DateTime.parse(key);
          String monthName = DateFormat.MMMM().format(date);
          newData.putIfAbsent(monthName, () => {'moods': [], 'average': 0});
          newData[monthName]!['moods'].addAll(value['moods']);
          newData[monthName]!['average'] += (value['average'] as num).toDouble();
        }
      });

      newData.forEach((month, data) {
        int totalMoods = data['moods'].length;
        double average = totalMoods > 0 ? data['average'] / totalMoods : 0;
        data['average'] = average;
      });

      moodData = newData;
    }

    drawmoodData = {};
    responseData2.forEach((key, value) {
      if (key != 'averagePercentage') {
        DateTime date = DateTime.parse(key);
        drawmoodData[date.toIso8601String()] = {
          'moods': value['moods'],
          'average': (value['average'] as num).toDouble()
        };
      }
    });

    await _setmoodweekly();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    DateTime datebefore = currentDate.subtract(Duration(days: daydatebefore));
    if (global.role == "student") {
      _getmood(context, datebefore);
    }
    if (global.role != "student") {
      _getstudentmood(context, datebefore, selectedClassId ?? 'all');
    }
    _setmoodweekly();
    moodData;

    classes = global.classesList;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
              backgroundColor: themeProvider.getBackgroundColor(),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.notifications_none,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
          IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/profile');
      },
      icon: Container(
        width: 40, // Ajustez la taille selon vos besoins
        height: 40, // Ajustez la taille selon vos besoins
        child: global.idimageprofil != ""
            ? ClipOval(
                child: Image.network(
                  global.idimageprofil,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.account_circle,
                size: 40,
                color: AppColors.purpleSchood,
              ),
      ),
        )
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
              Center(child: H2TextApp(text: "Trier par")),
              if (global.role != "student")
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
            _onClassDropdownChanged(selectedClassId!);
          });
        },
        items: ['Toute', ...classes.map((classe) => classe['name'] as String)].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: H4TextApp(text: value),
          );
        }).toList(),
      ),
    ),
  ),
              const SizedBox(height: 20),
              MyDropdown(
                onChanged: _onDropdownChanged,
              ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LineChartSample2(
                    moodData: moodData,
                    selectedOption: selectedOption,
                    gradient: [
                      AppColors.purpleSchood,
                      AppColors.pinkSchood,
                    ],
                    xbackgroundColor: themeProvider.getTextColor(),
                    ybackgroundColor: themeProvider.getBackgroundColor(),
                    colorstext: themeProvider.getTextColor(),
                  ),
                ],
              ),
            ),
            const Center(
              child: H2TextApp(
                text: "Semaines passées",
                color: AppColors.backgroundDarkmode,
              ),
            ),
            SizedBox(height: 20),
            Center(
                child: H4TextApp(
                    text: arraymood.length > 0 ? arraymood[0] : "Semaine 1: Pas de données")),
            SizedBox(height: 10),
            Center(
                child: H4TextApp(
                    text: arraymood.length > 1 ? arraymood[1] : "Semaine 2: Pas de données")),
            SizedBox(height: 10),
            Center(
                child: H4TextApp(
                    text: arraymood.length > 2 ? arraymood[2] : "Semaine 3: Pas de données")),
            SizedBox(height: 10),
            Center(
                child: H4TextApp(
                    text: arraymood.length > 3 ? arraymood[3] : "Semaine 4: Pas de données")),
            SizedBox(height: 10),
            Center(
                child: H4TextApp(
                    text: arraymood.length > 4 ? arraymood[4] : "Semaine 5: Pas de données")),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar:  BottomBarApp(
        indexapp: global.role == "administration" ? 1 : 2,
      ),
    );
  }
}

class MyDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const MyDropdown({Key? key, required this.onChanged}) : super(key: key);

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
        items: <String>['Semaine', 'Année'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: H4TextApp(
              text: value,
            ),
          );
        }).toList(),
      ),
    );
  }
}
