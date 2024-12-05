import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/delete.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;

class Person {
  final String id;
  final String firstname;
  final String lastname;

  Person({required this.id, required this.firstname, required this.lastname});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}

class SignalementScreen extends StatefulWidget {
  @override
  _SignalementScreenState createState() => _SignalementScreenState();
}

class _SignalementScreenState extends State<SignalementScreen> {
  List<Widget> bodyWidgets = [];
  bool isSortDescending = false; // Variable pour suivre l'ordre du tri

  @override
  void initState() {
    super.initState();
    _getSignalement();
  }

  // Fonction pour récupérer les signalements de l'utilisateur spécifique
  Future<void> _getSignalement() async {
    try {
      final getdata = GetClass();
      Response response = await getdata.getData(global.globalToken, "shared/report");
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> signalements =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print("Signalements récupérés : $signalements");

        // Filtrer les signalements pour la personne spécifique
// Filtrer les signalements pour la personne spécifique
signalements = signalements.where((signalement) {
  print("Signalement : $signalement");
  if (signalement['signaledBy'] != null) {
    print("SignaledBy ID : ${signalement['signaledBy']['_id']}");
  }
  return signalement['signaledBy'] != null &&
         signalement['signaledBy']['_id'] == global.idtoken; // Utiliser _id au lieu de id
}).toList();


        print("Signalements après filtrage : $signalements");

        // Formattage et tri des signalements
        signalements.forEach((signalement) {
          signalement["createdAt"] = DateTime.parse(signalement["createdAt"]);

          if (signalement.containsKey("type")) {
            if (signalement["type"] is Map<String, dynamic>) {
              Map<String, dynamic> typeMap = signalement["type"];
              List<String> types = typeMap.entries
                  .where((entry) => entry.value == true)
                  .map((entry) => _translateReason(entry.key))
                  .toList();
              signalement["type"] = types.join(', ');
            } else if (signalement["type"] is String) {
              signalement["type"] = _translateReason(signalement["type"]);
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
      } else {
        print("Erreur de réponse : ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur : $error");
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
// Fonction pour supprimer un signalement
Future<void> _deleteSignalement(String signalementId) async {
  try {
    final getdata = DeleteClass();
    final response = await getdata.deleteData(global.globalToken, "shared/report/$signalementId");
  print(signalementId);
  print(response.body);
    if (response.statusCode == 200) {
      // Suppression réussie, mettre à jour l'affichage
      setState(() {
        // Filtrer la liste des signalements pour supprimer celui qui a été supprimé
        bodyWidgets.removeWhere((widget) => (widget is ElevatedButton) &&
            widget.child is Text && (widget.child as Text).data!.contains(signalementId));
      });

      // Afficher un message de succès
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signalement supprimé'),
            content: const Text('Le signalement a été supprimé avec succès.'),
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
    } else {
      // Si la requête échoue, affiche une erreur
      _showErrorDialog('Échec de la suppression du signalement');
    }
  } catch (error) {
    _showErrorDialog('Une erreur est survenue lors de la suppression');
  }
}

// Fonction pour afficher un message d'erreur
void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
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

  // Affichage des détails du signalement
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
        title: const Text("Détails du Signalement"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage des photos des utilisateurs et noms
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
                      child: Text(
                        "${usersSignaled[0]['firstname']} ${usersSignaled[0]['lastname']}",
                        style: TextStyle(color: AppColors.textLightmode),
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
              // Affichage de la pastille
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


  // Liste des signalements
// Liste des signalements
List<Widget> _buildSignalementList(List<Map<String, dynamic>> signalements) {
  if (signalements.isEmpty) {
    return [
      SizedBox(height: 120,),
      Center(
        child: const H4TextApp(
        text:  "Aucun signalement trouvé.",
        
        ),
      ),
    ];
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
          _showDetailsPopup(signalement);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purpleSchood,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                signaledByName == global.name
                    ? "Vous avez signalé $userSignaledName"
                    : "$signaledByName a signalé $userSignaledName",
                style: TextStyle(
                  color: AppColors.textDarkmode,
                  fontSize: 14.0, // Ajustez la taille si nécessaire
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis, // Ajoute "..." si le texte est trop long
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
Center(
  child: 
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
              ),),
              ...bodyWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
