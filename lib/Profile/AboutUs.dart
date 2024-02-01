import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Profile/ContactPage.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H1TextApp(
              text: "About us",
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: H4TextApp(
                text:
                    "Bienvenue chez Schood! Nous sommes une équipe de 6 développeurs qui avons pour but de venir en aide aux élèves en difficulté et de les mettre en relation avec les personnes appropriées.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
