import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;

class SignalementScreen extends StatefulWidget {
  @override
  _SignalementScreenState createState() => _SignalementScreenState();
}

class _SignalementScreenState extends State<SignalementScreen> {
  List<Widget> bodyWidgets = [];

  @override
  void initState() {
    super.initState();
    _getSignalement();
  }

  Future<void> _getSignalement() async {
    final getdata = GetClass();
    Response response =
        await getdata.getData(global.globalToken, "shared/report");

    if (response.statusCode == 200) {
      // Convertissez la chaîne JSON en une liste de maps
      List<Map<String, dynamic>> signalements =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));

      // Convertissez la date au format DateTime pour permettre le tri
      signalements.forEach((signalement) {
        signalement["createdAt"] = DateTime.parse(signalement["createdAt"]);
      });

      // Triez la liste par date
      signalements.sort((a, b) => a["createdAt"].compareTo(b["createdAt"]));

      // Construisez la liste des widgets de signalements
      setState(() {
        bodyWidgets = _buildSignalementList(signalements);
      });
    } else {
      print(
          "Erreur lors de la récupération des signalements. Statut : ${response.statusCode}");
    }
  }

  Future<void> _showDetailsPopup(Map<String, dynamic> signalement) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Détails du Signalement"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text("ID: ${signalement["_id"]}"),
              Text("Utilisateur signalé: ${signalement["userSignaled"]}"),
              Text("Signalé par: ${signalement["signaledBy"]}"),
              Text("Date: ${signalement["createdAt"]}"),
              Text("Message: ${signalement["message"]}"),
              Text("Type de signalement: ${signalement["type"]}"),
              Text("Conversation: ${signalement["conversation"]}"),
              // Ajoutez d'autres champs selon vos besoins
            ],
          ),
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

  List<Widget> _buildSignalementList(List<Map<String, dynamic>> signalements) {
    return signalements.map((signalement) {
      String id = signalement["_id"];
      String userSignaled = signalement["userSignaled"];
      String userSignaledby = signalement["signaledBy"];
      DateTime date = signalement["createdAt"];
      String message = signalement["message"];
      String type = signalement["type"];
      String conversation = signalement["conversation"];

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            _showDetailsPopup(signalement);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purpleSchood,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H4TextApp(
                text: userSignaledby,
                color: AppColors.textDarkmode,
              ),
              H4TextApp(
                text: "à signaler $userSignaled",
                color: AppColors.textDarkmode,
              ),
            ],
          ),
        ),
      );
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
              H4TextApp(text: "Retour", color: themeProvider.getTextColor())
            ],
          ),
        ),
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
                  text: "Signalement",
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
