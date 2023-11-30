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

class HelpList extends StatelessWidget {
  const HelpList({super.key});

  _gethelp(BuildContext context) async {
    final getdata = GetClass();
    var id = global.globalToken;
    print(id);
    Response response =
        await getdata.getData(global.globalToken, "user/helpNumbers/:+$id");
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    _gethelp(context);
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
                ),
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H1TextApp(
                text: "Numéros gratuits",
                color: themeProvider.getTextColor(),
              ),
              const SizedBox(height: 60.0),
              const Center(
                child: Column(
                  children: [
                    HelpButton(
                      route: HelpIssues(
                        texthelp: text_help.text_drogues_services,
                        number: "0800231313",
                        title: "Drogue Info services",
                      ),
                      text: "Drogue Info services",
                    ),
                    HelpButton(
                      route: HelpIssues(
                        texthelp: text_help.text_ecoute_cannabis,
                        number: "0980980940",
                        title: "Écoute Canabis",
                      ),
                      text: "Écoute Canabis",
                    ),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_ecoute_alcool,
                          number: "0980980930",
                          title: "Écoute Alcool",
                        ),
                        text: "Ecoute Alcool"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_tabac_ecoute,
                          number: "3989",
                          title: "Tabac info service",
                        ),
                        text: "Tabac info service"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_sida_service,
                          number: "0800840800",
                          title: "Sida info services",
                        ),
                        text: "Sida info service"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_enfant_maltraite,
                          number: "119",
                          title: "Enfance maltraitée",
                        ),
                        text: "Enfance maltraitée"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_violences_conj,
                          number: "3919",
                          title: "Violences conjugales",
                        ),
                        text: "Violences conjugales"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_SOS_amitie,
                          number: "0972394050",
                          title: "SOS Amitié",
                        ),
                        text: "SOS Amitié"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_sans_abris,
                          number: "",
                          title: "Accueil sans abri",
                        ),
                        text: "Accueil sans abri"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_croix_rouge,
                          number: "0980980940",
                          title: "La croix rouge",
                        ),
                        text: "La Croix-rouge Ecoute"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_sante_jeunes,
                          number: "0980980940",
                          title: "Fil santé jeunes",
                        ),
                        text: "Fil santé jeunes"),
                    HelpButton(
                        route: HelpIssues(
                          texthelp: text_help.text_viols_femmes,
                          number: "0980980940",
                          title: "Viols femmes informations",
                        ),
                        text: "Viols femmes informations"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
