import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/HelpAdminScreen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/delete.dart';
import 'package:schood/request/patch.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;

class HelpIssues extends StatelessWidget {
  final String texthelp;
  final String number;
  final String title;
  final String email;
  final String id;
  final String idcat;

  // Déclarer les contrôleurs de texte ici pour les rendre accessibles dans toute la classe
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  HelpIssues({
    Key? key,
    required this.texthelp,
    required this.number,
    required this.title,
    required this.email,
    required this.id,
    required this.idcat
  }) : super(key: key) {
    // Initialiser les contrôleurs avec les valeurs existantes
    nameController.text = title;
    numberController.text = number;
    emailController.text = email;
    descriptionController.text = texthelp;
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
            if (isAdmin)
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
                      // Ouvre la boîte de dialogue de confirmation pour la suppression
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation de suppression"),
                            content: Text("Êtes-vous sûr de vouloir supprimer cet élément ?"),
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
                                  // Ferme la boîte de dialogue
                                  _deleteHelp(context, id, idcat);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HelpAdminScreen())); // Revenir deux fois en arrière

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              H1TextApp(text: title, color: AppColors.purpleSchood),
              const SizedBox(height: 60.0),
              Center(
                child: Column(
                  children: [
                    H4TextApp(
                      text: texthelp,
                      color: AppColors.purpleSchood,
                    ),
                    email.isNotEmpty
                        ? H4TextApp(
                            text: email,
                            color: AppColors.purpleSchood,
                          )
                        : Container(),
                    HelpCallButton(
                      number: number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: numberController,
                  decoration: InputDecoration(labelText: 'Numéro'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
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
                _modifyhelp(context, id, idcat); // Appeler _modifyhelp avec l'ID de l'élément à modifier
              },
            ),
          ],
        );
      },
    );
  }

  void _modifyhelp(BuildContext context, String id, String idcat) async {
    // Vérifications des champs
    String currentName = nameController.text.trim();
    String currentNumber = numberController.text.trim();
    String currentEmail = emailController.text.trim();
    String currentDescription = descriptionController.text.trim();

    if (currentName.isEmpty || currentNumber.isEmpty || currentEmail.isEmpty || currentDescription.isEmpty) {
      // Affiche un message d'erreur si un champ est vide
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Tous les champs doivent être remplis."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (currentNumber.length != 10) {
      // Affiche un message d'erreur si le numéro de téléphone ne fait pas 10 chiffres
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Le numéro de téléphone doit comporter exactement 10 chiffres."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    var data = {
      "email": currentEmail,
      "name": currentName,
      "telephone": currentNumber,
      "helpNumbersCategory": idcat,
      "description": currentDescription,
    };

    final patchdata = PatchClass();
    final response = await patchdata.patchData(global.globalToken, data, "adm/helpNumber/$id");

    if (response.statusCode == 200) {
      // Afficher une pop-up pour la confirmation de la modification
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
      print("Erreur lors de la modification");
    }
  }

  void _deleteHelp(BuildContext context, String id, String idcat) async {
    final getdata = DeleteClass();
    final response = await getdata.deleteData(global.globalToken, "adm/helpNumber/$id");

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
                  // Effectuer deux Navigator.pop() pour revenir en arrière
                  Navigator.of(context).pop();

                  Navigator.of(context).pop(); 

                  Navigator.of(context).pop(); 

                  Navigator.of(context).pop(); 
                  Navigator.of(context).pop();
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
}
