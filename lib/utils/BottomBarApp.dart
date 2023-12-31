// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:schood/DocsScreen.dart';
import 'package:schood/Help/HelpScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/WeeklyStats.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/style/AppColors.dart';

class BottomBarApp extends StatelessWidget {
  final int indexapp;

  const BottomBarApp({
    super.key,
    required this.indexapp,
  });

  @override
  Widget build(BuildContext context) {
    int checkrole() {
      if (global.role == 'student') {
        return 1;
      } else if (global.role == 'admin') {
        return 2;
      } else {
        return 0;
      }
    }

    int role = checkrole();
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            //color: iconColor,
            width: 1.2,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: indexapp,
        onTap: (int index) {
          if (index == 0 && role <= 2) {
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
          } else if (index == 1 && role <= 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const DocsScreen(),
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
                    const StatsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
          } else if (index == 3 && role <= 2) {
//            Navigator.pushReplacement(
//            );
          } else if (index == 4 && role <= 2) {
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
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.show_chart,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_rounded,
            ),
            label: '',
          ),
        ],
        selectedItemColor: AppColors.purpleSchood,
      ),
    );
  }
}
