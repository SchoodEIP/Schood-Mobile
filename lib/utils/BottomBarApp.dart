// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/HelpAdminScreen.dart';
import 'package:schood/Survey/SurveyScreen.dart';
// import 'package:schood/ChatScreen.dart';
import 'package:schood/Survey/SurveySummaryScreen.dart';
import 'package:schood/Chat/ConversationScreen.dart';
// import 'package:schood/DocsScreen.dart';
import 'package:schood/Help/HelpScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/WeeklyStats.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/main.dart';
import 'package:schood/style/AppColors.dart';

class BottomBarApp extends StatelessWidget {
  final int indexapp;

  const BottomBarApp({
    super.key,
    required this.indexapp,
  });

  @override
  Widget build(BuildContext context) {
    int indexapp2 = indexapp;


    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: 120,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: themeProvider.getTextColor(),
            //color: iconColor,
            width: 1.2,
          ),
        ),
      ), 
      child: global.role != 'administration' ?
      BottomNavigationBar(
        backgroundColor: themeProvider.getBarColor(),
        type: BottomNavigationBarType.fixed,
        currentIndex: indexapp2,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
          } else if (index == 1) {
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
          } else if (index == 2 ) {
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
          } else if (index == 3 ) {
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
          } else if (index == 4 ) {
            if (global.role == "administration" ){ Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HelpAdminScreen(),
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
                    const HelpScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );}
          }
        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Accueil',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.description,
            ),
            label: 'Questionnaire',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.show_chart,
            ),
            label: 'Statistique',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_rounded,
            ),
            label: 'Aide',
          ),
        ],
        selectedItemColor: AppColors.purpleSchood,
        unselectedItemColor: themeProvider.getTextColor(),
      ) :BottomNavigationBar(
        backgroundColor: themeProvider.getBarColor(),
        type: BottomNavigationBarType.fixed,
        currentIndex: indexapp2,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
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
                    const StatsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
            
          } else if (index == 2 ) {
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
          } else if (index == 3 ) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HelpAdminScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
          }
        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.show_chart,
            ),
            label: 'Statistique',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_rounded,
            ),
            label: 'Aide',
          ),
        ],
        selectedItemColor: AppColors.purpleSchood,
        unselectedItemColor: themeProvider.getTextColor(),
      )
    );
  }
}