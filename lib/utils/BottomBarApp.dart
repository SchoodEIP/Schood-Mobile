import 'package:flutter/material.dart';
import 'package:schood/ChatScreen.dart';
import 'package:schood/DocsScreen.dart';
import 'package:schood/HelpScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/WeeklyStats.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/style/AppColors.dart';

class BottomBarApp extends StatelessWidget {
  final int index_app;

  const BottomBarApp({
    required this.index_app,
  });

  @override
  Widget build(BuildContext context) {
    int check_role() {
      if (global.role == 'student')
        return 1;
      else if (global.role == 'admin')
        return 2;
      else
        return 0;
    }

    int role = check_role();

    return Container(
      width: 120,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.purple_Schood,
            width: 1.2,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index_app, // Index de l'élément actif
        onTap: (int index) {
          if (index == 0 && role <= 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
          } else if (index == 1 && role <= 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    DocsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
          } else if (index == 2 && role <= 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    StatsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
          } else if (index == 3 && role <= 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ChatScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
          } else if (index == 4 && role <= 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HelpScreen(),
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
            icon: Icon(Icons.home, color: AppColors.purple_Schood),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description,
              color: AppColors.purple_Schood,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.show_chart,
              color: AppColors.purple_Schood,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: AppColors.purple_Schood,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_rounded,
              color: AppColors.purple_Schood,
            ),
            label: '',
          ),
        ],
        selectedItemColor: AppColors.purple_Schood,
      ),
    );
  }
}
