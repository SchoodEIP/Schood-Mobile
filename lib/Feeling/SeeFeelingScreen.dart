import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/request/patch.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class SeeFeelingScreen extends StatefulWidget {
  const SeeFeelingScreen({Key? key}) : super(key: key);

  @override
  _SeeFeelingScreenState createState() => _SeeFeelingScreenState();
}

class _SeeFeelingScreenState extends State<SeeFeelingScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> feelings = [];
  List<Map<String, dynamic>> desanonymRequests = []; // Liste des demandes de désanonymisation

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    getFeeling();
    getactionofdesannonymous();

    // Initialisation de l'AnimationController pour animer la rotation de la cloche
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600), // Durée de l'animation ajustée pour plus de fluidité
    );

    // Définir l'animation de rotation de -30° à 30° avec une courbe de rebond pour un mouvement plus naturel
    _rotationAnimation = Tween<double>(begin: -30.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut, // Courbe plus naturelle et rebondissante
      ),
    );

    // Lancer l'animation en boucle avec effet de rebond
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

void desanonymmyfeeling(String id, String status) async {
  final patchData = PatchClass();
  var data = {
    'status': status,
  };
  final response = await patchData.patchData(context, data, "shared/desanonym/$id");
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    await getFeeling(); // Rafraîchit les ressentis
    await getactionofdesannonymous(); // Rafraîchit les demandes de désanonymisation
    setState(() {}); // Mise à jour de l'interface utilisateur
  } else {
    // Gestion des erreurs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Une erreur est survenue : ${response.body}")),
    );
  }
}


  // Récupérer les demandes de désanonymisation
   getactionofdesannonymous() async {
    final getData = GetClass();
    final response = await getData.getData(global.globalToken, "shared/desanonym");


    setState(() {
      desanonymRequests = List<Map<String, dynamic>>.from(jsonDecode(response.body));
    });
  }



  getFeeling() async {
    final getData = GetClass();
    final response = await getData.getData(global.globalToken, "student/mood");
    final List<dynamic> data = jsonDecode(response.body);

    setState(() {
      feelings = data.map((item) {
        String anonymity = item['annonymous'] ? 'anonyme' : 'public';
        DateTime dateTime = DateTime.parse(item['date']);
        String formattedDate = DateFormat('d MMMM yyyy à HH:mm', 'fr_FR').format(dateTime);

        List<String> moodIcons = ["😡", "☹️","😐", "🙂", "😄"];
        String moodIcon = item['mood'] >= 0 && item['mood'] < moodIcons.length
            ? moodIcons[item['mood']]
            : "❓";

        return {
          '_id': item['_id'],
          'user': item['user'],
          'mood': moodIcon,
          'date': formattedDate,
          'comment': item['comment'],
          'anonymous': anonymity,
          'facility': item['facility']
        };
      }).toList();
    });
  }

  // Afficher la pop-up avec les informations de la demande de désanonymisation
void showDesanonymRequestDialog(Map<String, dynamic> request) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Demande de désanonymisation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(request['createdBy']['picture']),
              radius: 30,
            ),
            SizedBox(height: 16),
            Text(
              "${request['createdBy']['firstname']} ${request['createdBy']['lastname']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Message: ${request['message']}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la pop-up
              desanonymmyfeeling(request['_id'], "refused"); // Envoi de la réponse "refused"
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Désanonymisation refusée.")),
              );
            },
            child: Text("Refuser", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la pop-up
              desanonymmyfeeling(request['_id'], "accepted"); // Envoi de la réponse "accepted"
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Désanonymisation acceptée.")),
              );
            },
            child: Text("Accepter", style: TextStyle(color: Colors.green)),
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
      body: feelings.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loader si les données ne sont pas prêtes
          : ListView.builder(
              itemCount: feelings.length,
              itemBuilder: (context, index) {
                var feeling = feelings[index];
                bool isAnonymous = feeling['anonymous'] == 'anonyme';
                // Vérifier si une demande de désanonymisation correspond à ce feeling
                bool  hasDesanonymRequest = desanonymRequests.any((request) {

                  return request['mood']['_id'] == feeling['_id']; // Compare 'reason' avec '_id' du feeling
                });

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: AppColors.purpleSchood,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.mood,
                      size: 40,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Ton Mood: ${feeling['mood']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Date: ${feeling['date']}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Comment: ${feeling['comment'] ?? 'Pas de commentaire'}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'En ${feeling['anonymous']}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        // Si c'est anonyme, afficher un bouton pour demander à désanonymiser
                        if (isAnonymous)
                          Row(
                            children: [
                             
                              SizedBox(width: 10),
                              // Afficher l'icône de la cloche avec l'animation de rotation si une demande de désanonymisation a été faite
                              if (hasDesanonymRequest)
                                AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _rotationAnimation.value * 3.14159 / 180,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.notifications,
                                          color: Colors.yellow,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          var request = desanonymRequests.firstWhere(
                                            (request) => request['mood']['_id'] == feeling['_id'],
                                          );
                                          showDesanonymRequestDialog(request);
                                        },
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                      ],
                    ),  
                  ),
                );
              },
            ),
    );
  }
}
