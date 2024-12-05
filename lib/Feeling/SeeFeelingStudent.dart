import 'package:flutter/material.dart';
import 'dart:convert'; // Pour manipuler les données JSON
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart'; 
import 'package:schood/global.dart' as global;
import 'package:schood/style/AppTexts.dart';

class SeeFeelingStudent extends StatefulWidget {
  @override
  _SeeFeelingStudentState createState() => _SeeFeelingStudentState();
}

class _SeeFeelingStudentState extends State<SeeFeelingStudent> {
  List<dynamic> moods = [];
  Map<String, bool> desanonymisationStatus = {}; // Dictionnaire pour stocker l'état des demandes

  // Fonction pour récupérer les moods depuis l'API
  Future<void> getAllMoods() async {
    final getData = GetClass();
    final response = await getData.getData(global.globalToken, "shared/moods/all");

    if (response.statusCode == 200) {
      try {
        final moodData = jsonDecode(response.body);
        if (moodData is List) {
          setState(() {
            moods = moodData;
          });
        }
      } catch (e) {
        print('Erreur lors du décodage du JSON : $e');
      }
    } else {
      print('Erreur lors de la récupération des moods : ${response.statusCode}');
    }
  }
// Fonction qui vérifie si le commentaire est un "default comment"
bool isDefaultComment(String? comment) {
  if (comment == null) {
    return false; // Si le commentaire est null, ce n'est pas un commentaire par défaut
  }

  // Expression régulière qui vérifie si le commentaire commence par "default comment" suivi d'un nombre
  RegExp regex = RegExp(r"^Default comment \d+$");

  return regex.hasMatch(comment); // Vérifie si le commentaire correspond à l'expression régulière
}

  // Fonction pour vérifier si la demande de désanonymisation a déjà été envoyée
  Future<void> checkIsAlreadySent() async {
    final getData = GetClass();
    final response = await getData.getData(global.globalToken, "shared/desanonym");

    if (response.statusCode == 200) {
      try {
        final desanonymisationData = jsonDecode(response.body);
        if (desanonymisationData is List) {
          // Mettre à jour l'état des demandes envoyées pour chaque mood
          for (var mood in moods) {
            var moodId = mood['_id']?.toString();
            if (moodId != null) {
              bool alreadySent = desanonymisationData.any((request) => request['mood'] == moodId);
              desanonymisationStatus[moodId] = alreadySent;
            }
          }
        }
      } catch (e) {
        print('Erreur lors du décodage du JSON : $e');
      }
    } else {
      print('Erreur lors de la récupération des demandes : ${response.statusCode}');
    }
  }

  // Fonction pour envoyer une demande de désanonymisation
  void sendDesanonymisation(String msg, String id, String idUser) async {
    final postData = PostClass();
    var data = {
      "user": idUser,
      "message": msg,
      "mood": id
    };
    final response = await postData.postDataAuth(global.globalToken, data, "shared/desanonym");

    if (response.statusCode == 200) {
      setState(() {
        desanonymisationStatus[id] = true; // Marquer la demande comme envoyée
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Demande de désanonymation envoyée avec succès!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'envoi de la demande.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAllMoods();
    checkIsAlreadySent();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> emojis = ["😄", "🙂", "😐", "☹️", "😡"];
    final Map<String, String> emojiValues = {
      "😄": "5",
      "🙂": "4",
      "😐": "3",
      "☹️": "2",
      "😡": "1",
    };
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
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
              backgroundColor: themeProvider.getBackgroundColor(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const H1TextApp(text: "Ressentis des étudiants"),
              const SizedBox(height: 15.0),
              moods.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: moods.length,
                      itemBuilder: (context, index) {
                        var mood = moods[index];
                        var user = mood['user'];
                        var moodValue = mood['mood'];
                        String emoji = emojis.firstWhere(
                          (e) => emojiValues[e] == moodValue, 
                          orElse: () => "😐"
                        );
                        String moodId = mood['_id']?.toString() ?? '';

                        return Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.all(16),
                              color: AppColors.purpleSchood,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: mood['annonymous']
                                  ? ClipOval(
                                      child: Container(
                                        color: Colors.grey,
                                        child: Icon(
                                          Icons.help_outline,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        user['picture'] ?? 'https://via.placeholder.com/40',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.person, size: 40);
                                        },
                                      ),
                                    ),
                                title: mood['annonymous']
                                  ? H4TextApp(text:'Utilisateur Anonyme', color: AppColors.backgroundLightmode,)
                                  : H4TextApp(text:'${user['firstname']} ${user['lastname']}', color: AppColors.backgroundLightmode,),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    H4TextApp(
                                      text:'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(mood['date']))}',
                                      color: AppColors.backgroundLightmode,
                                    ),
                                    SizedBox(height: 5),
                                    H4TextApp(text: 'Mood: $emoji', color: AppColors.backgroundLightmode),
                                    SizedBox(height: 5),
                                    H4TextApp(
                                      text: 'Commentaire: ${isDefaultComment(mood['comment']) ? 'Aucun commentaire' : (mood['comment'] ?? 'Pas de commentaire')}',
                                      color: AppColors.backgroundLightmode,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (mood['annonymous'] && global.role == "administration")
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: ElevatedButton(
                                  onPressed: desanonymisationStatus[moodId] ?? false 
                                      ? null 
                                      : () {
                                          TextEditingController messageController = TextEditingController();

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Demande de désanonymation"),
                                                content: TextField(
                                                  controller: messageController,
                                                  decoration: InputDecoration(
                                                    hintText: "Entrez un message pour la demande",
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Annuler"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      String message = messageController.text.trim();
                                                      String? moodId = mood['_id']?.toString();
                                                      String? userId = mood['user']?['_id']?.toString();

                                                      if (moodId != null && userId != null) {
                                                        sendDesanonymisation(message, moodId, userId);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("Demande de désanonymation envoyée.")),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("Données invalides.")),
                                                        );
                                                      }
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Envoyer"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                  child: Text(desanonymisationStatus[moodId] ?? false ? "Déjà envoyé" : "Envoyer une demande de désanonymation"),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
