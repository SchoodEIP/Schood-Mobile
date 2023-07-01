import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:schood/ChatScreen.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/CreateAccountScreen.dart';
import 'package:schood/DocsScreen.dart';
import 'package:schood/HelpScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/WeeklyStats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return MaterialApp(
      title: 'SCHOOD',
      initialRoute: _auth.currentUser != null ? '/home' : '/',
      routes: {
        '/': (context) => LoginPage(),
        '/create_account': (context) => CreateProfilePage(),
        '/home': (context) => HomeScreen(Userinfo: currentUser),
        '/docs': (context) => DocsScreen(Userinfo: currentUser),
        '/stats': (context) => StatsScreen(Userinfo: currentUser),
        '/chat': (context) => ChatScreen(Userinfo: currentUser),
        '/info': (context) => HelpScreen(Userinfo: currentUser),
        '/confirm_inscription': (context) => ConfirmationInscription(),
      },
    );
  }
}
