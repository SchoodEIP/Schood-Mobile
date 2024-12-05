import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notificationsData = [];

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
              H4TextApp(
                text: "Retour",
                color: themeProvider.getTextColor(),
              )
            ],
          ),
        ),
        /*actions: [
          if (global.role == "admin" || global.role == "teacher")
            IconButton(
              icon: Icon(Icons.add_rounded),
              onPressed: () {},
            ),
        ],*/
      ),
      body: FutureBuilder(
        future: _getNotification(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Construction des widgets à partir des données de la liste
            List<Widget> bodyWidgets =
                _buildNotificationList(notificationsData);

            return SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: H1TextApp(
                        text: "Notification",
                        color: themeProvider.getTextColor(),
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    ...bodyWidgets,
                  ],
                ),
              ),
            );
          } else {
            // Afficher un indicateur de chargement ou autre pendant le chargement des données
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _getNotification() async {
    final getdata = GetClass();
    Response response =
        await getdata.getData(global.globalToken, "shared/notifications");

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> alerts =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));

      // Comparer le concernedUser avec votre variable id
      String id = global.idtoken; // Remplacez ceci par votre variable id
      
      notificationsData =
          alerts.where((alert) => alert["concernedUser"] == id).toList();
    } else {
      print(
          "Erreur lors de la récupération des alertes. Statut : ${response.statusCode}");
    }
  }

List<Widget> _buildNotificationList(List<Map<String, dynamic>> notifications) {
  return notifications.map((notification) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {          _showPopup(notification["title"], notification["message"]);},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purpleSchood,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H3TextApp(
                text: "${notification["title"]}",
                color: AppColors.textDarkmode,
              ),
              H4TextApp(
                text: "${notification["message"]}",
                color: AppColors.textDarkmode,
              ),
            ],
          ),
        ),
      
    );
  }).toList();
}

void _showPopup(String title, String message) {
 showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message), // Affiche le message dans le corps de la boîte de dialogue
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Retour"), // Bouton avec le texte "Retour"
        ),
      ],
    );
  },
);

}}