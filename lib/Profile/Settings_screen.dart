// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            const H1TextApp(
              text: "Paramètres",
            ),
            const SizedBox(height: 120.0),
            Row(
              children: [
                const Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: H4TextApp(text: "Thème de l'application")),
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: LogoutButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}