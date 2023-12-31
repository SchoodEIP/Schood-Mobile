import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class HelpIssues extends StatelessWidget {
  final String texthelp;
  final String number;
  final String title;
  const HelpIssues(
      {super.key,
      required this.texthelp,
      required this.number,
      required this.title});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      final barColor = themeProvider.isDarkModeEnabled
          ? AppColors.backgroundDarkmode
          : AppColors.backgroundLightmode;
      return Scaffold(
          appBar: AppBar(
              backgroundColor: barColor,
              elevation: 0, // Pas d'ombre sous la barre
              automaticallyImplyLeading: false,
              title: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: AppColors.purpleSchood,
                    ),
                    SizedBox(width: 8),
                    H4TextApp(text: "Retour", color: AppColors.purpleSchood)
                  ],
                ),
              )),
          body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Alignement à gauche
                      children: [
                        H1TextApp(text: title, color: AppColors.purpleSchood),
                        const SizedBox(height: 60.0),
                        Center(
                            child: Column(children: [
                          H4TextApp(
                            text: texthelp,
                            color: AppColors.purpleSchood,
                          ),
                          HelpCallButton(
                            number: number,
                          )
                        ]))
                      ]))));
    });
  }
}
