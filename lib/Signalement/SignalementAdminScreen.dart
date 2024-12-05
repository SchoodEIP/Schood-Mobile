import 'dart:convert';

import 'package:intl/intl.dart'; // Importez pour le formatage de la date.
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;

class SignalementAdminScreen extends StatefulWidget {
  @override
  _SignalementAdminScreenState createState() => _SignalementAdminScreenState();
}

class _SignalementAdminScreenState extends State<SignalementAdminScreen> {
  List<Widget> bodyWidgets = [];
  bool isSortDescending = false; // Variable pour suivre l'ordre du tri

  @override
  void initState() {
    super.initState();
    _getSignalement();
  }

  // Fonction pour récupérer les signalements
void sendtraiting(String id, bool stat) async {
  String status = "seen";
  if (stat) {
    status = "responded";
  }
  print(status);

  final postdata = PostClass();
  var data = {
    "responseMessage": "Ok",
    "status": status
  };

  // Appel à l'API pour traiter le signalement
  final response = await postdata.postDataAuth(context, data, "shared/report/processing/$id");

  if (response.statusCode == 200) {
    // Affichage de la popup de confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Signalement traité"),
          content: const Text("Le signalement a été traité avec succès."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // Rafraîchir les données après le traitement
                _getSignalement();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  } else {
    // Si l'API a échoué
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Une erreur est survenue lors du traitement du signalement."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }
}

  void sendseentrating(String id) async{
        final postdata= PostClass();
        print("test");
    var data = {
      "responseMessage":"Ok",
      "status": "seen"};
    final response = await postdata.postDataAuth(context, data, "shared/report/processing/$id");
    print(response.statusCode);
    _getSignalement();

  }

  Future<void> _getSignalement() async {
    try {
      final getdata = GetClass();
      Response response = await getdata.getData(global.globalToken, "shared/report");
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> signalements =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print("Signalements récupérés : $signalements");


        signalements.forEach((signalement) {
          signalement["createdAt"] = DateTime.parse(signalement["createdAt"]);

          if (signalement.containsKey("type")) {
            if (signalement["type"] is Map<String, dynamic>) {
              Map<String, dynamic> typeMap = signalement["type"];
              typeMap.entries.forEach((entry) {

              });

              List<String> types = typeMap.entries
                  .where((entry) => entry.value == true)
                  .map((entry) => _translateReason(entry.key))
                  .toList();

              signalement["type"] = types.join(', ');
            } else if (signalement["type"] is String) {

              signalement["type"] = _translateReason(signalement["type"]);
            } else {
            }
          }
        });

        // Tri des signalements en fonction de l'option de tri
        if (isSortDescending) {
          signalements.sort((a, b) => b["createdAt"].compareTo(a["createdAt"])); // Du plus récent au plus ancien
        } else {
          signalements.sort((a, b) => a["createdAt"].compareTo(b["createdAt"])); // Du plus vieux au plus récent
        }

        setState(() {
          bodyWidgets = _buildSignalementList(signalements);
        });
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Une erreur est survenue'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Veuillez réessayer plus tard'),
              ),
            ],
          );
        },
      );
    }
  }

  // Traduction des types de signalement
  String _translateReason(String reason) {

    reason = reason.toLowerCase();
    switch (reason) {
      case "bullying":
        return "Harcèlement";
      case "badcomportment":
        return "Contenu offensant";
      case "spam":
        return "Spam";
      case "other":
        return "Autre";
      default:
        return "Autre";
    }
  }

  // Affichage des détails du signalement
Future<void> _showDetailsPopup(Map<String, dynamic> signalement) async {
  final usersSignaled = signalement['usersSignaled'];
  final signaledBy = signalement['signaledBy'];
  String formattedDate = DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(signalement['createdAt']);

  Color statusColor;
  String statusText;

  switch (signalement["status"]) {
    case "seen":
      statusColor = Colors.yellow;
      statusText = "Vu";
      break;
    case "responded":
      statusColor = Colors.green;
      statusText = "Traité";
      break;
    default:
      statusColor = Colors.red;
      statusText = "Non traité";
  }

  return showDialog(
    context: context,
    
    builder: (BuildContext context) {
      return AlertDialog(
        
        title: const H3TextApp(text:"Détails du Signalement"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage des utilisateurs
              if (usersSignaled != null && usersSignaled.isNotEmpty)
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: usersSignaled[0]['picture'] != null && usersSignaled[0]['picture'].isNotEmpty
                          ? NetworkImage(usersSignaled[0]['picture'])
                          : null,
                      radius: 30,
                      child: usersSignaled[0]['picture'] == null || usersSignaled[0]['picture'].isEmpty
                          ? Icon(Icons.help_outline, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: H4TextApp(
                        text: "${usersSignaled[0]['firstname']} ${usersSignaled[0]['lastname']}",
                        color: AppColors.textLightmode,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              // Affichage des informations de signalement
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: signaledBy['picture'] != null && signaledBy['picture'].isNotEmpty
                        ? NetworkImage(signaledBy['picture'])
                        : null,
                    radius: 30,
                    child: signaledBy['picture'] == null || signaledBy['picture'].isEmpty
                        ? Icon(Icons.help_outline, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: H4TextApp(
                      text: "Signalé par: ${signaledBy['firstname']} ${signaledBy['lastname']}",
                      color: AppColors.textLightmode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              H4TextApp(
                text: "Date: $formattedDate",
                color: AppColors.textLightmode,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              H4TextApp(
                text: "Message: ${signalement['message']}",
                color: AppColors.textLightmode,
              ),
              H4TextApp(
                text: "Type de signalement: ${signalement['type']}",
                color: AppColors.textLightmode,
              ),
              const SizedBox(height: 20),
              // Affichage du bouton "Traiter le signalement" uniquement si le statut n'est pas "responded"
              if (signalement["status"] != "responded")
                ElevatedButton(
                  onPressed: () {
                    sendtraiting(signalement["_id"], true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purpleSchood,
                  ),
                  child: const H8TextApp(
                    text: "Traiter le signalement",
                    color: AppColors.textDarkmode,
                  ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fermer'),
          ),
        ],
      );
    },
  );
}


List<Widget> _buildSignalementList(List<Map<String, dynamic>> signalements) {
  if (signalements.isEmpty) {
    print("Aucun signalement trouvé.");
    return [const Text("Chargement...")];
  }

  return signalements.map((signalement) {
    final usersSignaled = signalement['usersSignaled'];
    final signaledBy = signalement['signaledBy'];

    final String userSignaledName = (usersSignaled != null && usersSignaled.isNotEmpty)
        ? "${usersSignaled[0]['firstname']} ${usersSignaled[0]['lastname']}"
        : "Utilisateur inconnu";
    final String signaledByName = signaledBy != null
        ? "${signaledBy['firstname']} ${signaledBy['lastname']}"
        : "Inconnu";

    Color statusColor;
    String statusText;

    switch (signalement["status"]) {
      case "seen":
        statusColor = Colors.yellow;
        statusText = "Vu";
        break;
      case "responded":
        statusColor = Colors.green;
        statusText = "Traité";
        break;
      default:
        statusColor = Colors.red;
        statusText = "Non traité";
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if(signalement["status"]!= "responded")
          sendseentrating(signalement["_id"]);
          _showDetailsPopup(signalement);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purpleSchood,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Row(
          children: [
            // Le rond de couleur (statut)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 10), // Espacement
            // Texte du signalement
            Expanded(
              child: H4TextApp(text:
                signaledByName == global.name
                    ? "Vous avez signalé $userSignaledName"
                    : "$signaledByName a signalé $userSignaledName",
                    color: AppColors.backgroundLightmode,
              ),
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
        backgroundColor: themeProvider.getBackgroundColor(),
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
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const H1TextApp(text: "Mes ressenties"),
              const SizedBox(height: 60.0),

              // Ajout du Dropdown pour trier par date
              DropdownButton<bool>(
                value: isSortDescending,
                dropdownColor: themeProvider.getBackgroundColor(),
                onChanged: (bool? newValue) {
                  setState(() {
                    isSortDescending = newValue!;
                    _getSignalement(); // Recharger les signalements avec le nouvel ordre de tri
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: false,
                    child: H4TextApp(text:"Du plus vieux au plus récent"),
                  ),
                  DropdownMenuItem(
                    value: true,
                    child: H4TextApp(text:"Du plus récent au plus vieux"),
                  ),
                ],
              ),
              ...bodyWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
