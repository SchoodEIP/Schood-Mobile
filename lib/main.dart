import 'package:flutter/material.dart';
import 'package:schood/ChatScreen.dart';
import 'package:schood/Connexion_screen.dart';

import 'package:schood/DocsScreen.dart';
import 'package:schood/HelpScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/WeeklyStats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCHOOD',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomeScreen(),
        '/docs': (context) => DocsScreen(/*Userinfo: currentUser*/),
        '/stats': (context) => StatsScreen(/*Userinfo: currentUser*/),
        '/chat': (context) => ChatScreen(/*Userinfo: currentUser*/),
        '/info': (context) => HelpScreen(/*Userinfo: currentUser*/),
      },
    );
  }
}
