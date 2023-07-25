import 'package:flutter/material.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class HelpScreen extends StatelessWidget {
  /*final User? Userinfo;
  HelpScreen({required this.Userinfo});*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              signOutAndNavigateToLogin(context);
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: AppColors.purple_Schood,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            H1TextApp(text: "Aides", color: AppColors.background_darkMode),
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
      bottomNavigationBar: BottomBarApp(
        index_app: 4,
      ),
    );
  }
}
