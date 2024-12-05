// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schood/Admin/SeeAlerteScreen.dart';
import 'package:schood/Chat/ConversationScreen.dart';
import 'package:schood/Feeling/FeelingScreen.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/Signalement/SignalementAdminScreen.dart';
import 'package:schood/Signalement/SignalementScreen.dart';
import 'package:schood/Survey/SurveySummaryScreen.dart';
import 'package:schood/graphstats.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/WeeklyStats.dart';

import 'Survey/SurveyScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = global.name;

  @override
  Widget build(BuildContext context) {

         Uint8List ?photo = null;

    String welcometext = "Bonjour $firstName";
    if (global.role == "student"){
      welcometext = "Bonjour $firstName\nComment te sens tu aujourd'hui ?";
    }
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.getBackgroundColor(),
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
        )]),

      body: Padding(
        padding: const EdgeInsets.only(right: 32, left: 32, top: 32),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            H1TextApp(
              text:
                  welcometext,
            ),
            /*const WidgetCard(
              height: 444,
              width: 401,
              title: "Stats hebdomadaire",
              link: '/stats',
            ),*/

            const SizedBox(height: 64,),

            if(global.role == "student" || global.role == "teacher" || global.role == "administration")
              FeelingWidget(themeProvider:themeProvider),
            SizedBox(height: 253, child:StatsWidget(themeProvider: themeProvider)),
            if (global.role == "student"|| global.role == "teacher")
              SizedBox(height: 144, width: 401,child: SurveySummaryWidget(themeProvider: themeProvider,),),
              SizedBox(height: 290,child:ChatWidget(themeProvider: themeProvider),),
            /*if (global.role == "admin" || global.role == "teacher" || global.role =="administration")
              SizedBox(height: 144, child:HelpWidget(themeProvider:themeProvider)),*/
            if (global.role == "administration" ||global.role == "teacher")
              AlerteWidget(themeProvider:themeProvider),
              SignalementWidget(themeProvider:themeProvider),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 0,
      ),
    );
  }
}

class WidgetCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String link;

  const WidgetCard({
    Key? key,
    required this.width,
    required this.height,
    required this.title,
    required this.link,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      color: AppColors.purpleSchood,
      child: Container(
        width: width,
        height: height / 1.45,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2TextApp(text: title, color: AppColors.backgroundLightmode),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  if (link != "/signalement" &&
                      link != "/alerte" &&
                      link != "/notification")
                    Navigator.pushReplacementNamed(context, link);
                  else if (link == "/notification") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    H4TextApp(
                      text: "Voir plus",
                      color: AppColors.backgroundLightmode,
                    ),
                    Icon(
                      Icons.forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsWidget extends StatefulWidget {
  StatsWidget({Key? key, required this.themeProvider}) : super(key: key);
final themeProvider;
  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  Map<String, Map<String, dynamic>> moodData = {};

  @override
  void initState() {
    super.initState();
    if (global.role == "student")
    _getMood(context);
    else{
      _getstudentmood(context);
    }
  }
_getstudentmood(BuildContext context) async {
  final postdata = PostClass();
    DateTime currentDate = DateTime.now();
        DateTime datebefore = currentDate.subtract(Duration(days: 365));
  var data = {
    "fromDate": datebefore.toIso8601String(),
    "toDate": currentDate.toIso8601String(),
    "classFilter": "all"
  };
  final response = await postdata.postDataAuth(context, data, "shared/statistics/dailyMoods");
  Map<String, dynamic> responseData = jsonDecode(response.body);

    Map<String, Map<String, dynamic>> newData = {};
    responseData.forEach((key, value) {
      if (key != 'averagePercentage') {
        DateTime date = DateTime.parse(key);
        String monthName = DateFormat.MMMM().format(date);
        newData.putIfAbsent(monthName, () => {'moods': [], 'average': 0});
        newData[monthName]!['moods'].addAll(value['moods']);
        newData[monthName]!['average'] += value['average'];
      }
    });

    newData.forEach((month, data) {
      int totalMoods = data['moods'].length;
      double average = totalMoods > 0 ? data['average'] / totalMoods : 0;
      data['average'] = average;
    });

    setState(() {
      moodData = newData;
    });

}
 _getMood(BuildContext context) async {
    final postData = PostClass();
    DateTime currentDate = DateTime.now();
    DateTime dateBefore = currentDate.subtract(Duration(days: 365));
    Response response;
    var data = {
      "fromDate": dateBefore.toIso8601String(),
      "toDate": currentDate.toIso8601String()
    };
    response = await postData.postDataAuth(context, data, "student/statistics/moods");

    response = await postData.postDataAuth(context, data, "student/statistics/moods");

    Map<String, dynamic> responseData = jsonDecode(response.body);

    Map<String, Map<String, dynamic>> newData = {};
    responseData.forEach((key, value) {
      if (key != 'averagePercentage') {
        DateTime date = DateTime.parse(key);
        String monthName = DateFormat.MMMM().format(date);
        newData.putIfAbsent(monthName, () => {'moods': [], 'average': 0});
        newData[monthName]!['moods'].addAll(value['moods']);
        newData[monthName]!['average'] += value['average'];
      }
    });

    newData.forEach((month, data) {
      int totalMoods = data['moods'].length;
      double average = totalMoods > 0 ? data['average'] / totalMoods : 0;
      data['average'] = average;
    });

    setState(() {
      moodData = newData;
    });


  }

  @override
  Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);

    return  Scaffold(
            backgroundColor: themeProvider.getBackgroundColor(),      body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                H2TextApp(
                  text: "Stats hebdomadaire",
                   color: themeProvider.getIconColor(),
                ),
TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const StatsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
                  },
                  child: Row(
                    children: [
                      H4TextApp(
                        text: "Voir plus",
                    color: themeProvider.getIconColor(),
                      ),
                      const SizedBox(width: 4), // Espacement entre le texte et l'icône
                      Icon(
                        Icons.forward,  
                    color: themeProvider.getIconColor(),
                        size: 12,
                      ),
                    ],
                  ),
                ),         
              ],
            ), // Ajouter un espace entre les éléments
            LineChartSample2(
              moodData: moodData,
              selectedOption: "Mois",
              gradient: [AppColors.purpleSchood, AppColors.pinkSchood],
              xbackgroundColor: AppColors.backgroundDarkmode,
              ybackgroundColor: AppColors.backgroundLightmode,
              colorstext: themeProvider.getTextColor() ,
            ),
          ],
        ),
      
    );
  }
}

class SurveySummaryWidget extends StatefulWidget {
  SurveySummaryWidget({Key? key, required this.themeProvider}) : super(key: key);
final themeProvider;
  @override
  _SurveySummaryWidgetState createState() => _SurveySummaryWidgetState();
}

class _SurveySummaryWidgetState extends State<SurveySummaryWidget> {
  List<Map<String, dynamic>> questionnairesList = [];

  @override
  void initState() {
    super.initState();
    _getSurveyData();
  }

  Future<void> _getSurveyData() async {
     final getdata = GetClass();
      final response = await getdata.getData(global.globalToken, "shared/questionnaire");

    if (response.statusCode == 200) {
      try {
        final List<dynamic> surveyList = jsonDecode(response.body);
        setState(() {
          questionnairesList = surveyList.expand((survey) {
            final fromDate = survey['fromDate'];
            final toDate = survey['toDate'];
            final List<dynamic> questionnaires = survey['questionnaires'];
            return questionnaires.map((questionnaire) {
              return {
                'id': questionnaire['_id'],
                'title': questionnaire['title'],
                'fromDate': fromDate,
                'toDate': toDate,
              };
            }).toList();
          }).toList();
        });

      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Error fetching data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      
      
      child: 
          Column(children:[Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                H2TextApp(
                  text: "Questionnaires",
                   color: themeProvider.getIconColor(),
                ),
TextButton(
                  onPressed: () {
                  if (global.role == "teacher"){ Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SurveyScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );}
            else{
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SurveySummaryScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
            }
                  },
                  child: Row(
                    children: [
                      H4TextApp(
                        text: "Voir plus",
                    color: themeProvider.getIconColor(),
                      ),
                      const SizedBox(width: 4), // Espacement entre le texte et l'icône
                      Icon(
                        Icons.forward,  
                    color: themeProvider.getIconColor(),
                        size: 12,
                      ),
                    ],
                  ),
                ),         
              ],
            ),Column(
              children: _buildSurveyList(),
            ),]),
    );
  }

  List<Widget> _buildSurveyList() {
        final themeProvider = widget.themeProvider;
    List<Widget> widgets = [];
    int count = questionnairesList.length > 2 ? 2 : questionnairesList.length;


    for (int i = 0; i < count; i++) {
      widgets.add(H4TextApp(text: questionnairesList[i]['title'],color: themeProvider.getTextColor(),));
    }

    if (questionnairesList.length > 2) {
      widgets.add(H4TextApp(text:'...',color: themeProvider.getTextColor(),));
    }

    return widgets;
  }
}

class ChatWidget extends StatefulWidget {
  
   ChatWidget({Key? key, required this.themeProvider});
   final themeProvider;
     @override

  _ChatWidgetState createState() => _ChatWidgetState();
}
class _ChatWidgetState  extends State<ChatWidget>{
    List<Map<String, dynamic>> conversations = [];

Future<String> _getLastMessage(String id) async {
  final getdata = GetClass();
  var route = "user/chat/$id/messages";
  Response response2 = await getdata.getData(global.globalToken, route);

  try {
    final decodedData = jsonDecode(response2.body);

    if (decodedData is Map<String, dynamic>) {
      print("Les messages sont sous forme d'objet, pas de liste !");
      return ''; // Si c'est un objet, renvoyer une chaîne vide ou gérer cela
    }

    if (decodedData is List) {
      List<Map<String, dynamic>?> messagesList = decodedData
          .map((dynamic item) {
            if (item is Map<String, dynamic>) {
              return Map<String, dynamic>.from(item);
            } else {
              return null;
            }
          })
          .where((element) => element != null)
          .toList();

      messagesList.sort((a, b) {
        if (a?['date'] != null && b?['date'] != null) {
          return DateTime.parse(b!['date']!).compareTo(DateTime.parse(a!['date']!));
        } else {
          return 0;
        }
      });

      if (messagesList.isNotEmpty) {
        String messageContent = messagesList.first?['content'] ?? '';
        if (messageContent.length > 25) {
          return messageContent.substring(0, 25) + '...'; // Limiter à 25 caractères et ajouter '...'
        } else {
          return messageContent;
        }
      } else {
        return ''; // Aucun message trouvé
      }
    }
  } catch (e) {
    print("Erreur lors du décodage des messages : $e");
  }

  return ''; // En cas d'erreur, renvoyer une chaîne vide
}



Future<List<Map<String, dynamic>>> _getchatwidget() async {
  final getData = GetClass();
  final response = await getData.getData(global.globalToken, "user/chat");

  if (response.statusCode == 200) {
    try {
      final chatData = jsonDecode(response.body);

      if (chatData is Map<String, dynamic>) {
        print("Le JSON retourné est un objet et non une liste !");
        return [];
      }

      if (chatData is List) {
        List<Map<String, dynamic>> chatList = [];
        print("test1");
        for (var item in chatData) {
                  print("test2");
          if (item is Map<String, dynamic>) {
                    print("test3");
            String conversationId = item['_id'] ?? '';
            DateTime date = DateTime.parse(item['date'] ?? '');
            var participants = item['participants'];
            String lastMessageContent = await _getLastMessage(conversationId);

            if (participants is List) {
              chatList.add({
                'id': conversationId,
                'participants': participants,
                'date': date,
                'lastMessage': lastMessageContent,
              });
            }
          }
        }
        chatList.sort((a, b) => b['date'].compareTo(a['date']));
        chatList.forEach((conversation) {
          List participants = conversation['participants'];

          participants.removeWhere((participant) =>
              participant is Map<String, dynamic> &&
              participant['_id'] == global.idtoken);

          conversation['participants'] = participants;
        });

        return chatList;
      } else {
        print("Données inattendues !");
      }
    } catch (e) {
      print('Erreur lors du décodage du JSON : $e');
    }
  } else {
    print('Erreur lors de la récupération des données : ${response.statusCode}');
  }

  return [];
}



void initState() {
  super.initState();
  _loadChatData();

}

Future<void> _loadChatData() async {
  try {
    List<Map<String, dynamic>> chatList = await _getchatwidget();
    setState(() {
      conversations = chatList;
    });
  } catch (error) {
    print('Erreur lors du chargement des données de chat : $error');

  }
}

  @override

@override
Widget build(BuildContext context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
  return Column(
    
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                H2TextApp(
                  text: "Ma messagerie",
                   color: themeProvider.getIconColor(),
                ),
TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ConversationScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
                  },
                  child: Row(
                    children: [
                      H4TextApp(
                        text: "Voir plus",
                    color: themeProvider.getIconColor(),
                      ),
                      const SizedBox(width: 4), // Espacement entre le texte et l'icône
                      Icon(
                        Icons.forward,  
                    color: themeProvider.getIconColor(),
                        size: 12,
                      ),
                    ],
                  ),
                ),         
              ],
            ), 
   Row(
  children: [
    for (var i = 0; i < conversations.length && i < 2; i++)
      Expanded(
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: themeProvider.getBackgroundColor(),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  conversations[i]['participants'].length,
                  (index) {
                    String firstName =
                        conversations[i]['participants'][index]['firstname'] ??
                            'Unknown';
                    String lastName =
                        conversations[i]['participants'][index]['lastname'] ??
                            'Unknown';
                    return Text(
                      '$firstName $lastName',
                      style: TextStyle(fontWeight: FontWeight.bold, color: themeProvider.getTextColor()),
                    );
                  },
                ),
              ),
              SizedBox(height: 4),
              Text(conversations[i]['lastMessage'],style: TextStyle(color: themeProvider.getTextColor()),),
            ],
          ),
        ),
      ),
  ],
),

    SizedBox(height: 8), 
    Row(
      children: [
        for (var i = 2; i < conversations.length && i < 4; i++)
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeProvider.getBackgroundColor(),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversations[i]['participants'][0]['firstname'] + ' ' +
                    conversations[i]['participants'][0]['lastname'] ??
                    'Utilisateur inconnu',
                    style: TextStyle(fontWeight: FontWeight.bold,color: themeProvider.getTextColor()),
                  ),
                  SizedBox(height: 4),
                  Text(conversations[i]['lastMessage'],style: TextStyle(color: themeProvider.getTextColor()),),
                ],
              ),
            ),
          ),
      ],
    ),
  ],
);

}

}

class AlerteWidget extends StatefulWidget {
  const AlerteWidget({Key? key, required this.themeProvider}) : super(key: key);
  final themeProvider;

  @override
  _AlerteWidgetState createState() => _AlerteWidgetState();
}

class _AlerteWidgetState extends State<AlerteWidget> {


  @override
  void initState() {
    super.initState();
  }

 

  @override

Widget build(BuildContext context) {

          final themeProvider = Provider.of<ThemeProvider>(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          H2TextApp(
            text: "Mes alertes",
            color: themeProvider.getIconColor(),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SeeAlertScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ),
              );
            },
            child: Row(
              children: [
                H4TextApp(
                  text: "Voir plus",
                    color: themeProvider.getIconColor(),
                ),
                const SizedBox(width: 4), // Espacement entre le texte et l'icône
                Icon(
                  Icons.forward,
                    color: themeProvider.getIconColor(),
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
}
class HelpWidget extends StatefulWidget{
  
  HelpWidget({Key? key, required this.themeProvider}) : super(key: key);
final themeProvider;
  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState  extends State<HelpWidget> {

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(),
        Text(
          'Numéro gratuit',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          'Professionnels de la santé',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          'Numéro d\'urgence',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}

class SignalementWidget extends StatefulWidget {
  const SignalementWidget({Key? key, required this.themeProvider}) : super(key: key);
final themeProvider;
_SignalementWidgetState createState() => _SignalementWidgetState();
}
class _SignalementWidgetState extends State<SignalementWidget>{
  @override
  Widget build(BuildContext context) {
              final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          H2TextApp(
            text: "Mes signalements",
                   color: themeProvider.getIconColor(),
          ),
          TextButton(
            onPressed: () {
            if (global.role == "administration" ||global.role == "teacher"){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SignalementAdminScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ),
              );
            }if (global.role == "student") {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SignalementScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ),
              );
            }},
            child: Row(
              children: [
                H4TextApp(
                  text: "Voir plus",
                   color: themeProvider.getIconColor(),
                ),
                const SizedBox(width: 4), // Espacement entre le texte et l'icône
                Icon(
                  Icons.forward,
                   color: themeProvider.getIconColor(),
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [],
    );
  }
}

class FeelingWidget extends StatefulWidget {
  const FeelingWidget({Key? key, required this.themeProvider}) : super(key: key);
  final themeProvider;

  @override
  _FeelingWidgetState createState() => _FeelingWidgetState();
}

class _FeelingWidgetState extends State<FeelingWidget> {
  List<Map<String, dynamic>> feelings = [];
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    getFeeling();
  }

  getFeeling() async {
    try {
      final getData = GetClass();
      final response = await getData.getData(global.globalToken, "student/mood");
      final data = jsonDecode(response.body);

      // Vérification que la donnée est bien une liste
      if (data is List) {
        setState(() {
          feelings = data.map((item) {
            String anonymity = item['annonymous'] ? 'anonyme' : 'public';

            // Formater la date
            DateTime dateTime = DateTime.parse(item['date']);
            String formattedDate = DateFormat('d MMMM yyyy à HH:mm', 'fr_FR').format(dateTime);

            // Transformer 'mood' en smiley
            List<String> moodIcons = ["😡", "☹️", "😐", "🙂", "😄"];
            String moodIcon;
            if (item['mood'] >= 0 && item['mood'] < moodIcons.length) {
              moodIcon = moodIcons[item['mood']];
            } else {
              moodIcon = "❓"; // Icône par défaut pour les valeurs non valides
            }

            return {
              '_id': item['_id'],
              'user': item['user'],
              'mood': moodIcon,
              'date': formattedDate,
              'comment': item['comment'],
              'anonymous': anonymity,
              'facility': item['facility']
            };
          }).toList();
        });
      } else {
        // Si la donnée n'est pas une liste, on définit feelings à une liste vide
        setState(() {
          feelings = [];
        });
      }
    } catch (e) {
      // En cas d'erreur, on définit feelings à une liste vide
      setState(() {
        feelings = [];
      });
    } finally {
      setState(() {
        isLoading = false; // Fin du chargement
      });
    }
  }

  @override
  @override
Widget build(BuildContext context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
  String title = "Mes ressentis";
  if (global.role == "teacher"){
    title = "Ressentis classes";
  }
  if (isLoading) {
    return CircularProgressIndicator(); // Affiche un indicateur de chargement
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          H2TextApp(
            text: title,
                    color: themeProvider.getIconColor(),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const FeelingScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ),
              );
            },
            child: Row(
              children: [
                H4TextApp(
                  text: "Voir plus",
                    color: themeProvider.getIconColor(),
                ),
                const SizedBox(width: 4), // Espacement entre le texte et l'icône
                Icon(
                  Icons.forward,
                    color: themeProvider.getIconColor(),
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
      // Vérifie si l'utilisateur est un enseignant
      if (global.role != "teacher") ...[
        feelings.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: H4TextApp(text:'Pas de ressenti', ),
              ) // Affiche "Pas de ressenti" si la liste est vide
            : Column(
                children: [
                  // Affiche les ressentis en lignes de 2
                  for (var i = 0; i < 4; i += 2)
                    Row(
                      children: [
                        for (var j = i; j < i + 2 && j < feelings.length; j++)
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: themeProvider.getBackgroundColor(),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [  
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mood: ${feelings[j]['mood']}',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: themeProvider.getTextColor()),
                                    
                                  ),
                                  SizedBox(height: 4),
                                  Text('Date: ${feelings[j]['date']}',style: TextStyle(color: themeProvider.getTextColor()),),
                                  Text('Comment: ${feelings[j]['comment']}',style: TextStyle(color: themeProvider.getTextColor()),),
                                  Text('En ${feelings[j]['anonymous']}',style: TextStyle(color: themeProvider.getTextColor()),),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
      ],
    ],
  );
}
}