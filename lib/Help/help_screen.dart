// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/help_list.dart';
import 'package:schood/main.dart';
import 'package:schood/style/app_buttons.dart';
import 'package:schood/style/app_colors.dart';
import 'package:schood/style/app_texts.dart';
import 'package:schood/utils/bottom_bar_app.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.account_circle,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            H1TextApp(text: "Aides"),
            SizedBox(height: 120.0),
            Center(
              child: Column(
                children: [
                  HelpButtonWithArrow(
                      route: HelpList(), text: "Numéro gratuit"),
                  HelpButtonWithArrow(
                      route: HelpList(), text: "Professionnels de la santé"),
                  HelpButtonWithArrow(
                      route: HelpList(), text: "Numéro d'urgence"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 4,
      ),
    );
  }
}
