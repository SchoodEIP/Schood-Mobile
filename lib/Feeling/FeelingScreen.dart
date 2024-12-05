import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Feeling/CreateDailyFeelingScreen.dart';
import 'package:schood/Feeling/CreateFeelingScreen.dart';
import 'package:schood/Feeling/SeeFeelingScreen.dart';
import 'package:schood/Feeling/SeeFeelingStudent.dart';
import 'package:schood/Feeling/SeeTeacherFeelingScreen.dart';
import 'package:schood/Help/HelpScreenModify.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;

class FeelingScreen extends StatefulWidget {
  const FeelingScreen({Key? key}) : super(key: key);

  @override
  _FeelingScreenState createState() => _FeelingScreenState();
}

class _FeelingScreenState extends State<FeelingScreen> {
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
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())); 
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
              const SizedBox(height: 120.0),

              // Affichage conditionnel basé sur le rôle
              if (global.role == "student") ...[
                HelpButtonWithArrow(
                  route: const SeeFeelingScreen(),
                  text: "Voir les ressenties",
                ),
                HelpButtonWithArrow(
                  route: const CreateFeelingScreen(),
                  text: "Créer un ressentie",
                ),
                HelpButtonWithArrow(
                  route: const CreateDailyFeelingScreen(),
                  text: "Rentrer son ressentie journalier",
                ),
              ] else if (global.role == "teacher") ...[
                HelpButtonWithArrow(
                  route:  SeeTeacherFeelingScreen(),
                  text: "Voir le ressenties des classes",
                ),
              ],
              if (global.role =="teacher" || global.role == "administration") ...[
                 HelpButtonWithArrow(
                  route:  SeeFeelingStudent(),
                  text: "Voir le ressentie des étudiants",
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
