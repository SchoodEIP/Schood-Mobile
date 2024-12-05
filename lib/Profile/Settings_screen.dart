// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Profile/AboutUs.dart';
import 'package:schood/Profile/ContactPage.dart';
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
              backgroundColor: themeProvider.getBackgroundColor(),
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
                      child: H4TextApp(text: "Mode Jour / Nuit")),
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purpleSchood,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactPage()));
                    },
                    child: ButtonTextApp(
                      text: "Contactez-nous !",
                      color: AppColors.textDarkmode,
                    ))),
                                SizedBox(height: 10)
                    ,Center(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purpleSchood,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs()));
              },
              child: ButtonTextApp(
                text: "À propos de nous",
                color: AppColors.textDarkmode,
              ),
            )),
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
