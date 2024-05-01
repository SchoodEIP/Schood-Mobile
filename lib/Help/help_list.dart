import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:schood/Help/help_issues.dart';

import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

import '../utils/text_helps.dart' as text_help;
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
      name: json['name']?? '',
      telephone: json['telephone']?? '',
      email: json['email']?? '',
      helpNumbersCategory: json['helpNumbersCategory']?? '',
      description: json['description'],
      facility: json['facility'],
    );
  }
}

class HelpList extends StatelessWidget {
  const HelpList({super.key});

  Future<List<HelpNumber>> _gethelp(BuildContext context) async {
    final getdata = GetClass();
    var id = global.globalToken;
    Response response =
        await getdata.getData(global.globalToken, "user/helpNumbers");
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<HelpNumber> helpNumbers =
          data.map((json) => HelpNumber.fromJson(json)).toList();

      return helpNumbers;
    } else {
      // Gérer les erreurs de la requête ici.
      return []; // Ou vous pouvez renvoyer une liste vide en cas d'erreur.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HelpNumber>>(
        future: _gethelp(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  CircularProgressIndicator(), // Centrez l'indicateur de chargement.
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Erreur: ${snapshot.error}'), // Centrez le message d'erreur.
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                  'Aucune donnée disponible.'), // Centrez le message d'absence de données.
            );
          } else {
            final helpNumbers = snapshot.data!;
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
                            text: "Retour", color: themeProvider.getTextColor())
                      ],
                    ),
                  )),
              body: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: H1TextApp(
                          text: "Numéros gratuits",
                          color: themeProvider.getTextColor(),
                        ),
                      ),
                      const SizedBox(height: 60.0),
                      Padding(padding:  EdgeInsets.all(16),
                      child:
                      ListView(
                        shrinkWrap: true,
                        children: helpNumbers.map((helpNumber) {
                          return HelpButton(
                            route: HelpIssues(
                              texthelp: helpNumber.description,
                              number: helpNumber.telephone,
                              title: helpNumber.name,
                              email: helpNumber.email,
                            ),
                            text: helpNumber.name,
                          );
                        }).toList(),
                      ),)
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
