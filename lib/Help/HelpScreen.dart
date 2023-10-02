// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            H1TextApp(text: "Aides", color: AppColors.backgroundDarkmode),
            SizedBox(height: 120.0),
            Center(
              child: Column(
                children: [
                  HelpButtonWithArrow(route: null, text: "Numéro gratuit"),
                  HelpButtonWithArrow(
                      route: null, text: "Professionnels de la santé"),
                  HelpButtonWithArrow(route: null, text: "Numéro d'urgence"),
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
