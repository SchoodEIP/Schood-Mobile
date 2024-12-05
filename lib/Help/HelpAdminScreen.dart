import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/CreateHelpScreen.dart';
import 'package:schood/Help/HelpScreen.dart';
import 'package:schood/Help/HelpScreenModify.dart';
import 'package:schood/Help/help_list.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;

class HelpAdminScreen extends StatefulWidget {
  const HelpAdminScreen({Key? key}) : super(key: key);

  @override
  _HelpAdminScreenState createState() => _HelpAdminScreenState();
}

class _HelpAdminScreenState extends State<HelpAdminScreen> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
              backgroundColor: themeProvider.getBackgroundColor(),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.notifications_none, size: 40, color: AppColors.purpleSchood),
            ),
          ),
         IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/profile');
      },
      icon: Container(
        width: 40, // Ajustez la taille selon vos besoins
        height: 40, // Ajustez la taille selon vos besoins
        child: global.idimageprofil != ""
            ? ClipOval(
                child: Image.network(
                  global.idimageprofil,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.account_circle,
                size: 40,
                color: AppColors.purpleSchood,
              ),
      ),
        )
        ],
      ),
      body: const SingleChildScrollView(child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H1TextApp(text: "Aides administrateur"),
            SizedBox(height: 120.0),
             HelpButtonWithArrow( route: HelpModifyScreen() ,text: "Voir les numéros d'aides",
             ),HelpButtonWithArrow( route: CreateHelpScreen() ,text: "Créer un numéro d'aide",
             ),]))),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 3,
      ),
    );
  }
}
