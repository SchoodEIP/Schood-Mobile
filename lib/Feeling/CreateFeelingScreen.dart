import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:schood/main.dart';
import 'package:schood/request/post.dart';

import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;

class CreateFeelingScreen extends StatefulWidget {
  const CreateFeelingScreen({Key? key}) : super(key: key);

  @override
  _CreateFeelingScreenState createState() => _CreateFeelingScreenState();
}

class _CreateFeelingScreenState extends State<CreateFeelingScreen> {
  final List<String> emojis = ["😄", "🙂", "😐", "☹️", "😡"];
  final Map<String, String> emojiValues = {
    "😄": "4",
    "🙂": "3",
    "😐": "2",
    "☹️": "1",
    "😡": "0",
  };

  String? selectedEmoji;
  bool isAnonymous = false;
  final TextEditingController feedbackController = TextEditingController();

  _sendFeeling() async {
    if (selectedEmoji == null || feedbackController.text.isEmpty) {
      // Afficher une alerte si le smiley ou le commentaire n'est pas rempli
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Veuillez sélectionner une humeur et entrer un commentaire."),
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

    var route = "student/mood";
    var data = {
      "mood": int.parse(emojiValues[selectedEmoji]!),
      "comment": feedbackController.text,
      "annonymous": isAnonymous,
    };

    final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);
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
                  Navigator.pop(context, true); // Retourne une valeur indiquant que les données doivent être rafraîchies
 // Remplacer '/home' par le nom de votre route pour HomeScreen
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
              H1TextApp(text: "Créer un ressenti"),
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
              Text(
                "Comment vous sentez-vous?",
                style: TextStyle(
                  fontSize: 18,
                  color: themeProvider.getTextColor(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: feedbackController,
                maxLines: 3,
                style: TextStyle(color: themeProvider.getTextColor()),
                
                decoration: InputDecoration(
                  
                  border: OutlineInputBorder(),
                  hintText: "Entrez votre ressenti ici...",
                  hintStyle: TextStyle(color: themeProvider.getTextColor())
                 

                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isAnonymous,
                    onChanged: (bool? value) {
                      setState(() {
                        isAnonymous = value!;
                      });
                    },
                  ),
                  Text(
                    "En anonyme ?",
                    style: TextStyle(
                      fontSize: 18,
                      color: themeProvider.getTextColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(child:ElevatedButton(
                style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleSchood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
                onPressed: _sendFeeling,
                child: H4TextApp(text: "Envoyer",color: AppColors.textDarkmode,),
                
              )),
            ],
          ),
        ),
      ),
    );
  }
}
