// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schood/Chat/ConversationScreen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

import 'package:open_file/open_file.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import '../global.dart' as global;
import 'package:path_provider/path_provider.dart';


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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.id, required this.participants});

  final String id;
  final List<dynamic> participants;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isTextFieldEmpty = true;
  //String id = global.globalToken;
  List<Map<String, dynamic>> messages = [];
  List<String> selectedParticipantIds = [];
  List<String> selectedReasons =
  
      []; 
          List<Person> persons = [];
List<Map<String, dynamic>> participants = [];


  @override
 @override
void initState() {
  super.initState();
  participants = List<Map<String, dynamic>>.from(widget.participants);
  _getmessage(context);
  Timer.periodic(Duration(seconds: 10), (timer) {
    _getmessage(context);
  });
  messageController.addListener(() {
    setState(() {
      isTextFieldEmpty = messageController.text.isEmpty;
    });
  });
}

  String? filePath;
  File? file;

void _openFilePicker() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.isNotEmpty) {
    String? filePath = result.files.single.path;

    if (filePath != null) {
      setState(() {
        file = File(filePath);
      });
    }
  } else { 
    print("Aucun fichier sélectionné.");
  }
}
List<String> _getExistingParticipantIds() {
  return widget.participants.map((participant) => participant['_id'] as String).toList();
}
String _getUserNameById(String userId) {
  // Vérifiez si l'ID de l'utilisateur est le même que le token global
  if (userId == global.idtoken) {
    return 'Vous'; // ou le nom que vous souhaitez afficher pour l'utilisateur actuel
  }

  // Recherchez l'utilisateur dans la liste des participants
  final participant = widget.participants.firstWhere(
    (participant) => participant['_id'] == userId,
    orElse: () => null, // Retourne null si l'utilisateur n'est pas trouvé
  );

  // Vérifiez si le participant a été trouvé
  if (participant != null) {
    final firstname = participant['firstname'] ?? 'Inconnu';
    final lastname = participant['lastname'] ?? '';
    return '$firstname $lastname'.trim();
  } else {
    return 'Inconnu'; // Nom par défaut
  }
}
_adduser(bool shareHistory) async {
  // Get the existing participants' IDs
  List<String> existingParticipantIds = _getExistingParticipantIds();

  // Get the IDs of new participants to be added
  List<String> newParticipants = selectedParticipantIds.where((id) => !existingParticipantIds.contains(id)).toList();

  // If there are no new participants, show an alert and return
  if (newParticipants.isEmpty) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Aucun nouvel utilisateur"),
          content: Text("Tous les utilisateurs sélectionnés sont déjà dans la conversation."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    return;
  }

  // Check if history should be shared
  if (shareHistory == false) {
    // Combine existing participants' IDs with new participants' IDs, and include your own ID
    List<String> allParticipants = existingParticipantIds + newParticipants + [global.idtoken];

    // Prepare the data with all participant IDs
    var data = {
      "participants": allParticipants,  // Send both existing, new participant IDs, and your own ID
    };

    var route = "user/chat";
    final postclass = PostClass();
    Response response = await postclass.postDataAuth(context, data, route);

    if (response.statusCode == 200) {
      print("Participants (including history) added successfully.");
        Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ConversationScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
    } else {
      print("Erreur lors de l'ajout des participants avec historique - ${response.statusCode}");
    }
  } else {
    // If history is not to be shared, add only new participants
    var idconv = widget.id;
    var route = "user/chat/$idconv/addParticipants";
    var data = {
      "participants": newParticipants,
    };

    final postclass = PostClass();
    Response response = await postclass.postDataAuth(context, data, route);

    if (response.statusCode == 200) {
      // Update the participants list with the new participants
      setState(() {
        participants.addAll(newParticipants.map((id) => {
          "_id": id,
          "firstname": "NomParDéfaut", // You can update this to get the actual first name
          "lastname": "NomParDéfaut"   // You can update this to get the actual last name
        }).toList());
      });

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Utilisateur ajouté"),
            content: Text("Les utilisateurs ont bien été ajoutés."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ConversationScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                },
                child: Text("Retour"),
              ),
            ],
          );
        },
      );
    } else {
      print("Erreur lors de l'ajout des participants - ${response.statusCode}");
    }
  }
}




  void _showMultiSelectParticipants() async {

    await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {

            return AlertDialog(
              title: const Text('Sélectionnez les participants'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: widget.participants.map((participant) {
                    String? participantId = participant['_id'];
                    String? firstName = participant['firstname'];
                    String? lastName = participant['lastname'];

                    if (participantId != null &&
                        firstName != null &&
                        lastName != null) {
                      String fullName = '$firstName $lastName';
                      return CheckboxListTile(
                        title: Text(fullName),
                        value: selectedParticipantIds.contains(participantId),
                        onChanged: (isSelected) {
                          setState(() {
                            if (isSelected!) {
                              selectedParticipantIds.add(participantId);

                            } else {
                              selectedParticipantIds.remove(participantId);
                            }
                          });
                        },
                      );
                    } else {
                      return const SizedBox(); // Gérer le cas où les données du participant sont incomplètes
                    }
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedParticipantIds);

                  },
                  child: const Text('Valider'),
                ),
              ],
            );
          },
        );
      },
    );

  }



void _sendFile(String id) async {
  try {
    var route = "user/chat/$id/newFile";
    Map<String, dynamic> data = {};
    final postclass = PostFileClass();

    if (file != null) {
      Response response = await postclass.postDataWithFile(data, route, file!);
      if (response.statusCode == 200) {
      } else {
        print("Erreur lors de l'envoi du fichier - ${response.statusCode}");
      }
    } else {
      print("Aucun fichier sélectionné.");
    }
  } catch (error) {
    print("Erreur lors de l'envoi du fichier - $error");
  }
}

  void _sendMessage(String message, BuildContext context) async {
    if (file== null){
    try {
      var id = widget.id;
      var route = "user/chat/$id/newMessage";
      var data = {
        'content': message,
      };
      final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);
      if (response.statusCode == 200) {
        messageController.clear();
ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Message envoyé'),
      duration: Duration(seconds: 2),
    ),
  );
        _getmessage(context);
      } else {
        print("Erreur lors de l'envoi du message - ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de l'envoi du message - $error");
    }
  }
  else{
     try {
      var id = widget.id;
      var route = "user/chat/$id/newMessage";
      var data = {
        'content': message,
      };
      final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);
      if (response.statusCode == 200) {
        messageController.clear();
ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Message et fichier envoyé'),
      duration: Duration(seconds: 2),
    ),
  );
        _getmessage(context);
      } else {
        print("Erreur lors de l'envoi du message - ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de l'envoi du message - $error");
    }
    _sendFile(widget.id);
    file= null;
  }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

_getUserData() async {
  final getData = GetClass();
  final response = await getData.getData(global.globalToken, "user/chat/users");
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    persons = data.map((personData) => Person.fromJson(personData)).toList();

    for (var person in persons) {
      print(
          'ID: ${person.id}, Firstname: ${person.firstname}, Lastname: ${person.lastname}');
    }
    // Notify the UI to rebuild
    setState(() {});
  }
}


_getfile(BuildContext context, String id) async {
  final getdata = GetClass();

  var route = "user/file/$id";
  Response response = await getdata.getData(global.globalToken, route);
  try {
    if (response.statusCode == 200) {
      // Obtenez le répertoire de téléchargement de l'utilisateur
      Directory? appDocDir = await getDownloadsDirectory();
      if (appDocDir != null) {
        String appDocPath = appDocDir.path;

        // Vérifie si le serveur fournit un nom de fichier dans l'en-tête Content-Disposition
        String fileName = id;
        if (response.headers.containsKey('content-disposition')) {
          var contentDisposition = response.headers['content-disposition'];
          var fileNameMatch = RegExp('filename=(["\']?)([^"\';]*)').firstMatch(contentDisposition!);
          if (fileNameMatch != null && fileNameMatch.groupCount >= 2) {
            fileName = fileNameMatch.group(2)!;
          }
        }

        // Chemin complet pour enregistrer le fichier
        String filePath = path.join(appDocPath, fileName);

        // Écrivez le corps de la réponse dans le fichier
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        OpenFile.open(filePath);
        // Faites quelque chose avec le fichier téléchargé, par exemple ouvrez-le
      } else {
        print("Impossible d'obtenir le répertoire de téléchargement.");
      }
    } else {
      // La requête a échoué, gérer l'erreur
      print('Échec du téléchargement du fichier : ${response.statusCode}');
    }
  } catch (error) {
    print(error);
  }
}


  void _sendreport() async {
    final postdata = PostClass();
  for (int i = 0; i < selectedReasons.length; i++) {
  // Vérifier chaque condition et remplacer la chaîne si nécessaire
  if (selectedReasons[i] == "Harcèlement") {
    selectedReasons[i] = "bullying";
  } else if (selectedReasons[i] == "Contenu offensant") {
    selectedReasons[i] = "badcomportment";
  } else if (selectedReasons[i] == "Spam") {
    selectedReasons[i] = "spam";
  } else {
    selectedReasons[i] = "other";
  }
}

    var conversation = widget.id;
    var route = "shared/report";

    var data = {
      "userSignaled": selectedParticipantIds,
      "message": _messageController.text,
      "conversation": conversation,
      "type": "other",
    };
    Response response = await postdata.postDataAuth(context, data, route);

  }

  _getmessage(BuildContext context) async {
    final getdata = GetClass();

    var id = widget.id;
    var route = "user/chat/$id/messages";
    Response response2 = await getdata.getData(global.globalToken, route);

    List<dynamic> messageData = jsonDecode(response2.body);

    List<Map<String, dynamic>?> messagesList = messageData
        .map((dynamic item) {
          if (item is Map<String, dynamic>) {
            return Map<String, dynamic>.from(item);
          } else {
            return null;
          }
        })
        .where((element) => element != null)
        .toList();
    messagesList.sort((a, b) {
      if (a?['date'] != null && b?['date'] != null) {
        return DateTime.parse(a!['date']!)
            .compareTo(DateTime.parse(b!['date']!));
      } else {
        return 0;
      }
    });

    setState(() {
      print(messagesList);
      messages = messagesList
          .where((element) => element != null)
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

void _showSelectUserDialog(BuildContext context) async {
  // Fetch users before displaying the dialog
  await _getUserData();

  bool _shareHistory = false; // Variable pour la case à cocher

  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            title: const Text('Sélectionnez un utilisateur'),
            content: Column(
              mainAxisSize: MainAxisSize.min, // Pour s'adapter à la taille du contenu
              children: [
                DropdownButtonFormField<String>(
                  items: persons.map((Person person) {
                    return DropdownMenuItem<String>(
                      value: person.id,
                      child: Text('${person.firstname} ${person.lastname}'),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedParticipantIds.add(value!);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Choisir un utilisateur',
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _shareHistory,
                      onChanged: (bool? value) {
                        setState(() {
                          _shareHistory = value!;
                        });
                      },
                    ),
                    const Text('Partager l\'historique ?'),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _adduser(_shareHistory); // Passer l'état de la Checkbox
                },
                child: const Text('Valider'),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    //_getmessage(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.getBackgroundColor(),
        elevation: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const H4TextApp(
              text: 'Avec ',
            ),
            H3TextApp(
  text: widget.participants
      .map<String>((participant) {
        String firstname = participant['firstname'] ?? 'Inconnu';
        String lastname = participant['lastname'] ?? '';
        return '$firstname $lastname'.trim();
      })
      .join(', '),
),

          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, color: AppColors.purpleSchood),
            onPressed: () {
              _showSelectUserDialog(context);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: messages.map((message) {
                      String content = message['content'] ?? '';
                      String time = message['date'] ?? '';
                      String userId = message['user'] ?? '';
                      String file = message['file'] ?? '';
                      final userName = _getUserNameById(userId);

                      DateTime dateTime =
                          DateTime.tryParse(time) ?? DateTime.now();
                      String mois = DateFormat('MMMM', 'fr_FR').format(dateTime);
                      String heure =
                          '${dateTime.day} $mois ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                      AlignmentDirectional alignment = userId == global.idtoken
                          ? AlignmentDirectional.centerEnd
                          : AlignmentDirectional.centerStart;
                      return Align(
                        alignment: alignment,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: userId == global.idtoken
                                ? AppColors.pinkSchood
                                : AppColors.purpleSchood, 
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              H8TextApp(text:userName, color: userId == global.idtoken ? AppColors.textLightmode : AppColors.textDarkmode  ),H8TextApp(
        text: '$content', color: userId == global.idtoken ? AppColors.textLightmode : AppColors.textDarkmode 
                              ),
                              if (file != '' && file.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _getfile(context, file);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.download_rounded,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      H8TextApp(text:'Fichier attaché',
                                      ),
                                    ],
                                  ),
                                ), // Utilisez une couleur différente pour le texte si nécessaire
                              H8TextApp(text: '$heure',
                                 color: userId == global.idtoken ? AppColors.textLightmode : AppColors.textDarkmode  ),
                              // Utilisez une couleur différente pour le texte si nécessaire
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Container(height: 1, color: themeProvider.getTextColor()),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        keyboardAppearance: themeProvider.getkeyboardColor(),
                    decoration: InputDecoration(
                      counterStyle:
                          TextStyle(color: themeProvider.getTextColor()),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: themeProvider
                                .getTextColor()), // Couleur de la bordure quand le champ n'est pas en focus
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: themeProvider
                                .getTextColor()), // Couleur de la bordure quand le champ est en focus
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: 'Saisissez votre message',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                    style: GoogleFonts.inter(
                        fontSize: 18, color: themeProvider.getTextColor()),
                    controller: messageController,
                    maxLines: 2,
                    maxLength: 325,
                  )),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: isTextFieldEmpty ? Colors.grey : Colors.green,
                    ),
                    onPressed: () {
                      if (!isTextFieldEmpty)
                       FocusScope.of(context).unfocus();
                        _sendMessage(messageController.text, context);
        
                    },
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle_rounded,
                        size: 30,
                        color:  AppColors.purpleSchood
                      ),
                      onPressed: () {
                        _openFilePicker();
                        //sendDataWithFile(context);
                      })
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 3,
      ),
    );
  }
}

