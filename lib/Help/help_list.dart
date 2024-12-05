import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/HelpAdminScreen.dart';
import 'package:schood/Help/help_issues.dart';
import 'package:schood/main.dart';
import 'package:schood/request/delete.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/patch.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import '../utils/text_helps.dart' as text_help;
import 'package:schood/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;

class HelpNumber {
  final String id;
  final String name;
  final String telephone;
  final String email;
  final String helpNumbersCategory;
  final String description;
  final String facility;

  HelpNumber({
    required this.id,
    required this.name,
    required this.telephone,
    required this.email,
    required this.helpNumbersCategory,
    required this.description,
    required this.facility,
  });

  factory HelpNumber.fromJson(Map<String, dynamic> json) {
    return HelpNumber(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
      helpNumbersCategory: json['helpNumbersCategory'] ?? '',
      description: json['description'] ?? '',
      facility: json['facility'] ?? '',
    );
  }
}

class HelpList extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const HelpList({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  _HelpListState createState() => _HelpListState();
}

class _HelpListState extends State<HelpList> {
  List<HelpNumber> helpNumbers = [];
  TextEditingController nameController = TextEditingController(); 

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.categoryName;
    _gethelp();
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modifier l'aide"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Titre de la catégorie'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sauvegarder"),
              onPressed: () {
                _modifyhelpcategory(widget.categoryId);
              },
            ),
          ],
        );
      },
    );
  }

  void _modifyhelpcategory(String id) async {
    String currentTitle = nameController.text.isNotEmpty
        ? nameController.text
        : widget.categoryName;

    var data = {
      "name": currentTitle,
    };

    final patchdata = PatchClass();
    Response response = await patchdata.patchData(global.globalToken, data, "adm/helpNumbersCategory/$id");

    if (response.statusCode == 200) {

        // Affiche un message de confirmation et retourne à l'écran précédent
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Modification effectuée"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                 onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HelpAdminScreen())); // Revenir deux fois en arrière
                },
                ),
              ],
            );
          },
        );
    
    } else {
      // Gérer les erreurs ici
 showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Ce nom estiste déjà"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();// Revenir deux fois en arrière
                  },
                ),
              ],
            );});
    }
  }

  void _deleteHelpcategory(String id) async {
    final getdata = DeleteClass();
    Response response = await getdata.deleteData(global.globalToken, "adm/helpNumbersCategory/$id");

    if (response.statusCode == 200) {
      // Afficher une pop-up pour la confirmation de la suppression
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Suppression effectuée"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HelpAdminScreen())); // Revenir deux fois en arrière
                },
              ),
            ],
          );
        },
      );
    } else {
      // Gérer les erreurs ici
      print("Erreur lors de la suppression");
    }
  }

  _gethelp() async {
    final getdata = GetClass();
    Response response = await getdata.getData(global.globalToken, "user/helpNumbers/${widget.categoryId}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        helpNumbers = data.map((json) => HelpNumber.fromJson(json)).toList();
      });
    } else {
      print('Failed to load help numbers');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isAdmin = global.role == "administration";

    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.getBackgroundColor(),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context); // Retour à l'écran précédent
              },
              child: Row(
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
            if (isAdmin && widget.categoryName != "default" && widget.categoryName != "Autres" && widget.categoryName != "Autre")
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: themeProvider.getTextColor(),
                    onPressed: () {
                      _showEditDialog(context); // Ouvre la boîte de dialogue pour modification
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    color: themeProvider.getTextColor(),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation de suppression"),
                            content: Text("Êtes-vous sûr de vouloir supprimer cette catégorie ?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Annuler"),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                                },
                              ),
                              TextButton(
                                child: Text("Supprimer"),
                                onPressed: () {
                                  _deleteHelpcategory(widget.categoryId); // Supprime la catégorie
                                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: H1TextApp(
                text: widget.categoryName,
                color: themeProvider.getTextColor(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: helpNumbers.isEmpty
                    ? Center(
                        child: H2TextApp(
                          text: "Pas d'aide dans cette section",
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: helpNumbers.map((helpNumber) {
                          return HelpButton(
                            route: HelpIssues(
                              texthelp: helpNumber.description,
                              number: helpNumber.telephone,
                              title: helpNumber.name,
                              email: helpNumber.email,
                              id: helpNumber.id,
                              idcat: widget.categoryId,
                            ),
                            text: helpNumber.name,
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
