import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _gethelp(BuildContext context) async {
      final getdata = Get_Class();
      var global;
      try {
        Response response2 = await getdata.getData(
            global.globalToken, "user/helpNumber/register");
        Map<String, dynamic> helpData = jsonDecode(response2.body);
        var email = helpData["email"];
        var number = helpData["telephone"];
        var name = helpData["name"];
        var facility = helpData["facility"];
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text('Une erreur s\'est produite.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {},
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H1TextApp(
              text: "Paramètres",
              color: AppColors.background_darkMode,
            ),
            SizedBox(height: 120.0),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Thème de l'application",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return Switch(
                      value: themeProvider.isDarkModeEnabled,
                      onChanged: (bool value) {
                        themeProvider.isDarkModeEnabled = value;
                      },
                    );
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      _gethelp(context);
                    },
                    child: Text("Tests"))
              ],
            ),
            // Utilisez Expanded pour occuper tout l'espace vertical restant
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                // Bouton de déconnexion
                child: LogoutButton(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarApp(
        index_app: 3,
      ),
    );
  }
}
