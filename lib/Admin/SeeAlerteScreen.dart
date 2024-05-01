import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/utils/ErrorMessage.dart';

class SeeAlertScreen extends StatefulWidget {
  @override
  _SeeAlertScreenState createState() => _SeeAlertScreenState();
}

class _SeeAlertScreenState extends State<SeeAlertScreen> {
  List<Widget> bodyWidgets = [];
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _getAlert();
  }

  void _showAddAlertPopup(BuildContext context) {
    String title = '';
    String message = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ajouter une alerte"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Titre de l\'alerte'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Message'),
                onChanged: (value) {
                  message = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendAlert(context, title, message);
                Navigator.of(context).pop();
              },
              child: Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }

  _sendAlert(BuildContext context, title, String message) async {
    final getdata = GetClass();
    Response reponse2 =
        await getdata.getData(global.globalToken, "user/profile");

    ErrorChecker.checkError(context, reponse2);
    String roleId = "";
    Map<String, dynamic> responseData = json.decode(reponse2.body);

    Map<String, dynamic> roleData = responseData["role"];
    roleId = roleData["_id"];
    var data = {'title': title, 'message': message, 'role': roleId};
    final postclass = PostClass();
    Response response =
        await postclass.postDataAuth(context, data, "shared/alert");
    print(response.statusCode);
    ErrorChecker.checkError(context, response);
  }

  Future<void> _getAlert() async {
    final getdata = GetClass();
    Response response =
        await getdata.getData(global.globalToken, "shared/alert");

    List<Map<String, dynamic>> alerts =
        List<Map<String, dynamic>>.from(jsonDecode(response.body));
    ErrorChecker.checkError(context, response);
    setState(() {
      bodyWidgets = _buildAlertList(alerts);
    });
  }

  Future<void> _showDetailsPopup(Map<String, dynamic> alert) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: H2TextApp(text: "${alert["title"]}"),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H3TextApp(
                    text:
                        "Alerté par: ${alert["createdBy"]['firstname'] + ' ' + alert["createdBy"]['lastname']}"),
                SizedBox(
                  height: 20,
                ),
                H4TextApp(text: "${alert["message"]}"),
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(20),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAlertList(List<Map<String, dynamic>> alerts) {
    return alerts.map((alert) {
      String title = alert["title"] ?? "";
      DateTime createdAt = DateTime.parse(alert["createdAt"]);
      String createdBy = alert["createdBy"]['firstname'] +
              ' ' +
              alert["createdBy"]['lastname'] ??
          "";
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.purpleSchood,
                borderRadius: BorderRadius.circular(26),
              ),
              child: InkWell(
                onTap: () {
                  _showDetailsPopup(alert);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H4TextApp(
                        text: "Créée le $createdAt",
                        color: AppColors.textDarkmode,
                      ),
                      H4TextApp(
                        text: "Titre: $title",
                        color: AppColors.textDarkmode,
                      ),
                      H4TextApp(
                        text: "Par: $createdBy",
                        color: AppColors.textDarkmode,
                      ),
                    ],
                  ),
                ),
              )));
    }).toList();
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded),
            onPressed: () {
              _showAddAlertPopup(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: H1TextApp(
                  text: "Alerte",
                  color: themeProvider.getTextColor(),
                ),
              ),
              const SizedBox(height: 60.0),
              ...bodyWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
