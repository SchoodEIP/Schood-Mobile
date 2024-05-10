// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:schood/Admin/SeeAlerteScreen.dart';
import 'package:schood/Admin/signalement_screen.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/WeeklyStats.dart';

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
    if (global.idimageprofil != "") {
      photo = base64Decode(global.idimageprofil);
    }
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
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
           IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/profile');
      },
      icon: Container(
        width: 40, // Ajustez la taille selon vos besoins
        height: 40, // Ajustez la taille selon vos besoins
        child: /*global.idimageprofil != ""
            ? ClipOval(
                child: Image.memory(
                  photo!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : */Icon(
                Icons.account_circle,
                size: 40,
                color: AppColors.purpleSchood,
              ),
      ),
        )]),

      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            H1TextApp(
              text:
                  'Bonjour $firstName\nComment te sens tu aujourd\'hui ?',
            ),
            const WidgetCard(
              height: 344,
              width: 401,
              title: "Stats hebdomadaire",
              link: '/stats',
            ),
            const WidgetCard(
              height: 216,
              width: 401,
              title: "Questionnaires",
              link: '/surveySummary',
            ),
            const WidgetCard(
              height: 500,
              width: 401,
              title: "Messagerie",
              link: '/chat',
            ),
            const WidgetCard(
              height: 286,
              width: 401,
              title: "Numéros d'aides",
              link: '/info',
            ),
            const WidgetCard(
              height: 216,
              width: 401,
              title: "Notification",
              link: '/notification',
            ),
            if (global.role == "admin")
              const WidgetCard(
                height: 216,
                width: 401,
                title: "Signalements",
                link: '/signalement',
              ),
            if (global.role == "admin" || global.role == "teacher")
              const WidgetCard(
                height: 216,
                width: 401,
                title: "Alerte",
                link: '/alerte',
              ),
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

  Widget getContentWidget() {
    if (link == '/stats') {
      return const Expanded(child: StatsWidget());
    } else if (link == '/surveySummary') {
      return const Expanded(child: SurveySummaryWidget());
    } else if (link == '/chat') {
      return  Expanded(child: ChatWidget());
    } else if (link == '/info') {
      return const Expanded(child: HelpWidget());
    } else {
      return Container();
    }
  }

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
            getContentWidget(),
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
                  } else if (link == "/signalement") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignalementScreen(),
                      ),
                    );
                  } else if (link == "/alerte") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SeeAlertScreen()));
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

class StatsWidget extends StatelessWidget {
  const StatsWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.purpleSchood,
      body: Column(
        
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsGraphHomePage(name: "L", value: 40),
              StatsGraphHomePage(name: "M", value: 30),
              StatsGraphHomePage(name: "M", value: 95),
              StatsGraphHomePage(name: "J", value: 79),
              StatsGraphHomePage(name: "V", value: 100),
              StatsGraphHomePage(name: "S", value: 45),
              StatsGraphHomePage(name: "D", value: 100),
            ],
          ),
        ],
      ),
    );
  }
}

class SurveySummaryWidget extends StatelessWidget {
  const SurveySummaryWidget({Key? key});

  Future<String?> _getStoredSurveyId() async {
    final cacheManager = DefaultCacheManager();
    FileInfo? fileInfo = await cacheManager.getFileFromCache('survey_id');
    if (fileInfo != null && fileInfo.file != null) {
      List<int> bytes = await fileInfo.file!.readAsBytes();
      return utf8.decode(bytes);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getStoredSurveyId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error loading survey ID: ${snapshot.error}');
        }

        String? surveyId = snapshot.data;

        return Container(
          child: Text(
            'Survey $surveyId A Compléter',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}

class ChatWidget extends StatefulWidget {
  
   ChatWidget({Key? key});
   
     @override

  _ChatWidgetState createState() => _ChatWidgetState();
}
class _ChatWidgetState  extends State<ChatWidget>{
    List<Map<String, dynamic>> conversations = [];

Future<String> _getLastMessage(String id) async {
  final getdata = GetClass();

  var route = "user/chat/$id/messages";
  Response response2 = await getdata.getData(global.globalToken, route);

  List<dynamic> messageData = jsonDecode(response2.body);

  List<Map<String, dynamic>?> messagesList = messageData
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


Future<List<Map<String, dynamic>>> _getchatwidget() async {
  final getData = GetClass();  
  final response = await getData.getData(global.globalToken, "user/chat");

  if (response.statusCode == 200) {
    try {
      final chatData = jsonDecode(response.body);

      if (chatData is List) {
        List<Map<String, dynamic>> chatList = [];

        for (var item in chatData) {
          String conversationId = item['_id'];
          DateTime date = DateTime.parse(item['date']);
          var participants = item['participants'];
          String lastMessageContent = await _getLastMessage(conversationId); // Attendre le résultat

          if (participants is List) {
            chatList.add({
              'id': conversationId,
              'participants': participants,
              'date': date,
              'lastMessage': lastMessageContent,
            });
          }
        }
        chatList.sort((a, b) => b['date'].compareTo(a['date']));
        chatList.forEach((conversation) {
  List participants = conversation['participants'];

  // Parcourir chaque participant dans la liste des participants
  participants.removeWhere((participant) =>
      participant['_id'] == global.idtoken);

  conversation['participants'] = participants;
});      print(chatList);

        return chatList;
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
        print(conversations);
    });
  } catch (error) {
    print('Erreur lors du chargement des données de chat : $error');

  }
}

  @override

@override
Widget build(BuildContext context) {

  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   Row(
  children: [
    for (var i = 0; i < conversations.length && i < 2; i++)
      Expanded(
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              SizedBox(height: 4),
              Text(conversations[i]['lastMessage']),
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
                color: Colors.white,
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(conversations[i]['lastMessage']),
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

class AlerteWidget extends StatelessWidget {
  const AlerteWidget({Key? key});

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

class HelpWidget extends StatelessWidget {
  const HelpWidget({Key? key});

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

class SignalementWidget extends StatelessWidget {
  const SignalementWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [],
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
class StatsGraphHomePage extends StatelessWidget {
  final String name;
  final double value;

  const StatsGraphHomePage({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: 10,
          color: Colors.transparent, // Set your desired background color here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 100 - value,
                width: 10,
              ),
              Container(
                height: value,
                width: 10,
                decoration: BoxDecoration(
                  color: AppColors.backgroundLightmode,
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
            ],
          ),
        ),
        Text(name, style: TextStyle(color: AppColors.textDarkmode)),
      ],
    );
  }
}