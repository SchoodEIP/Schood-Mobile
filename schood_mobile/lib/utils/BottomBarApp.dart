import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schood/ChatScreen.dart';
import 'package:schood/DocsScreen.dart';
import 'package:schood/HelpScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/WeeklyStats.dart';

class BottomBarApp extends StatelessWidget {
  final int index_app;
  final User? Userinfo;
  const BottomBarApp({required this.index_app, required this.Userinfo});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: index_app, // Index de l'élément actif
      onTap: (int index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HomeScreen(
                Userinfo: Userinfo,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DocsScreen(
                Userinfo: Userinfo,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  StatsScreen(
                Userinfo: Userinfo,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ChatScreen(
                Userinfo: Userinfo,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        } else if (index == 4) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HelpScreen(
                Userinfo: Userinfo,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: 'Docs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Aide',
        ),
      ],
    );
  }
}
