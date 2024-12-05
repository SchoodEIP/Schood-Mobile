import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:schood/main.dart';
import 'package:schood/request/post.dart';

import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;

class CreateDailyFeelingScreen extends StatefulWidget {
  const CreateDailyFeelingScreen({Key? key}) : super(key: key);

  @override
  _CreateDailyFeelingScreenState createState() => _CreateDailyFeelingScreenState();
}

class _CreateDailyFeelingScreenState extends State<CreateDailyFeelingScreen> {
  final List<String> emojis = ["😄", "🙂", "😐", "☹️", "😡"];
  final Map<String, String> emojiValues = {
    "😄": "4",
    "🙂": "3",
    "😐": "2",
    "☹️": "1",
    "😡": "0",
  };

  String? selectedEmoji;


  _sendFeeling() async {
    if (selectedEmoji == null) {
      // Afficher une alerte si le smiley ou le commentaire n'est pas rempli
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Veuillez sélectionner une humeur du jour "),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    var route = "student/dailyMood";
    var data = {
      "mood": int.parse(emojiValues[selectedEmoji]!),
    };

    final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);
      print(response.statusCode);
      // Afficher une confirmation après l'envoi réussi
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Ressenti envoyé"),
            content: Text("Votre ressenti a bien été envoyé."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  
                  Navigator.of(context).pop(); // Remplacer '/home' par le nom de votre route pour HomeScreen
                },
                child: Text("Retour"),
              ),
            ],
          );
        },
      );
  
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
              )
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
              H1TextApp(text: "Créer son ressenti journalier"),
              const SizedBox(height: 16),
              Text(
                "Sélectionner votre humeur:",
                style: TextStyle(
                  fontSize: 18,
                  color: themeProvider.getTextColor(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: emojis.map((emoji) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedEmoji = emoji;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedEmoji == emoji
                              ? AppColors.purpleSchood
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            
              const SizedBox(height: 8),
             
              const SizedBox(height: 16),
             
              const SizedBox(height: 16),
Center(child:ElevatedButton(
                style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleSchood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),                child: H4TextApp(text: "Envoyer",color: AppColors.textDarkmode,), 
                onPressed: _sendFeeling,

              ),)
            ],
          ),
        ),
      ),
    );
  }
}
