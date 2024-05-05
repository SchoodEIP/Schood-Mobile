import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
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
  List<Person> persons = [];

  @override
  void initState() {
    super.initState();
    _getSignalement();
  }

  Future<void> _getSignalement() async {
    try{
    final getdata = GetClass();
    Response response = await getdata.getData(global.globalToken, "shared/report");

    if (response.statusCode == 200) {
      // Convertir la chaîne JSON en une liste de maps
      List<Map<String, dynamic>> signalements =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
      // Convertir la date au format DateTime pour permettre le tri
      signalements.forEach((signalement) {
        signalement["createdAt"] = DateTime.parse(signalement["createdAt"]);
          String type = signalement["type"];
  if (type == "other") {
    signalement["type"] = "Autre";
  } else if (type == "badcomportment") {
    signalement["type"] = "Contenu offensant";
    
  }else if (type == "bullying") {
    signalement["type"] = "Harcèlement";}
    else if (type == "spam"){
      signalement["type"] = "Spam";
    }
      });

      // Trier la liste par date
      signalements.sort((a, b) => a["createdAt"].compareTo(b["createdAt"]));

      // Obtenir les données des personnes
      await _getUserData();

      // Construire la liste des widgets de signalements avec les détails des personnes
      setState(() {
        bodyWidgets = _buildSignalementList(signalements, persons);
      });
    } else {
      print(
          "Erreur lors de la récupération des signalements. Statut : ${response.statusCode}");
    }
    }catch(error){ showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Une erreur est survenue'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                                Navigator.of(context).pop();
              },
              child: Text('Veuillez reessayer plus tard'),
            ),
          ],
        );});}
  }

  Future<void> _getUserData() async {
    try{
    final getData = GetClass();
    final response = await getData.getData(global.globalToken, "user/chat/users");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      persons = data.map((personData) => Person.fromJson(personData)).toList();

      for (var person in persons) {
        print(
            'ID: ${person.id}, Firstname: ${person.firstname}, Lastname: ${person.lastname}');
      }
    }}catch(error){ showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Une erreur est survenue'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                                Navigator.of(context).pop();
              },
              child: Text('Veuillez reessayer plus tard'),
            ),
          ],
        );});}
  }

Future<void> _showDetailsPopup(Map<String, dynamic> signalement) async {
    // Recherche de la personne correspondante pour l'utilisateur signalé
    Person? userSignaled = persons.firstWhere((person) => person.id == signalement["userSignaled"], orElse: () => Person(id: "", firstname: "", lastname: ""));
    // Recherche de la personne correspondante pour l'utilisateur signalé par
    Person? signaledBy = persons.firstWhere((person) => person.id == signalement["signaledBy"], orElse: () => Person(id: "", firstname: "", lastname: ""));
    print(signalement);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Détails du Signalement"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H4TextApp(text:"Utilisateur signalé: ${userSignaled?.firstname ?? "Utilisateur inconnu"} ${userSignaled?.lastname ?? ""}", color: AppColors.textLightmode,),
              H4TextApp(text:"Signalé par: ${signaledBy?.firstname ?? "Utilisateur inconnu"} ${signaledBy?.lastname ?? ""}",color: AppColors.textLightmode),
              H4TextApp(text:"Date: ${signalement["createdAt"]}",color: AppColors.textLightmode),
              H4TextApp(text:"Message: ${signalement["message"]}",color: AppColors.textLightmode),
              H4TextApp(text:"Type de signalement: ${signalement["type"]}",color: AppColors.textLightmode),
              //Text("Conversation: ${signalement["conversation"]}"),
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



  List<Widget> _buildSignalementList(List<Map<String, dynamic>> signalements, List<Person> persons) {
    // Afficher une liste vide en attendant que les données soient chargées
    if (signalements.isEmpty) {
      return [Text("Chargement...")];
    }

    // Afficher la liste des signalements avec les noms d'utilisateur mis à jour
    return signalements.map((signalement) {
      String id = signalement["_id"] ?? "";
      String userSignaled = signalement["userSignaled"] ?? "";
      String userSignaledby = signalement["signaledBy"] ?? "";
      DateTime date = signalement["createdAt"] ?? "";
      String message = signalement["message"] ?? "";
      String type = signalement["type"] ?? "";
      String conversation = signalement["conversation"] ?? "";
      // Recherche de la personne correspondante
      Person? personSignaled = persons.firstWhere((person) => person.id == userSignaled, orElse: () => Person(id: "", firstname: "", lastname: ""));
      Person? personSignaledBy = persons.firstWhere((person) => person.id == userSignaledby, orElse: () => Person(id: "", firstname: "", lastname: ""));

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

              ButtonTextApp( // Utiliser ButtonTextApp pour définir le style de votre bouton
                text: "${personSignaledBy.firstname}"+" "+ "${personSignaledBy.lastname} à signaler ${personSignaled.firstname}" +" "+ "${personSignaled.lastname}",
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
