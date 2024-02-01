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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeProvider.getBackgroundColor(),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: AppColors.purpleSchood,
                  ),
                  const SizedBox(width: 8),
                  H4TextApp(text: "Retour", color: themeProvider.getTextColor())
                ],
              ),
            )),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
  }
}
