import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class HelpIssues extends StatelessWidget {
  final String text_help;
  final String number;
  final String title;
  HelpIssues(
      {required this.text_help, required this.number, required this.title});
  Widget build(BuildContext context) {
    /*return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      final barColor = themeProvider.isDarkModeEnabled
          ? AppColors.background_darkMode
          : AppColors.background_lightMode;*/
    return Scaffold(
        appBar: AppBar(
            //backgroundColor: barColor,
            elevation: 0, // Pas d'ombre sous la barre
            automaticallyImplyLeading: false,
            title: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: AppColors.purple_Schood,
                  ),
                  SizedBox(width: 8),
                  H4TextApp(text: "Retour", color: AppColors.purple_Schood)
                ],
              ),
            )),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Alignement à gauche
                    children: [
                      H1TextApp(text: title, color: AppColors.purple_Schood),
                      SizedBox(height: 60.0),
                      Center(
                          child: Column(children: [
                        H4TextApp(
                          text: text_help,
                          color: AppColors.purple_Schood,
                        ),
                        HelpCallButton(
                          number: number,
                        )
                      ]))
                    ]))));
  }
}
