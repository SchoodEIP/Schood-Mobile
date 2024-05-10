// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import '../global.dart' as global;
import 'package:path_provider/path_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.id, required this.participants})
      : super(key: key);

  final String id;
  final List<dynamic> participants;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isTextFieldEmpty = true;
  String id = global.globalToken;
  List<Map<String, dynamic>> messages = [];
  List<String> selectedParticipantIds = [];
  late Timer _timer;
  List<String> selectedReasons =
      []; 

  @override
  void initState() {
    print(widget.participants);
    super.initState();
    _getmessage(context);
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
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
        // Maintenant, vous avez un objet File 'file' que vous pouvez utiliser.
        print("Chemin du fichier : ${file?.path}");
        // Faites ce que vous voulez avec le fichier...
      });
    }
  } else {
    print("Aucun fichier sélectionné.");
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
                      return SizedBox(); // Gérer le cas où les données du participant sont incomplètes
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
        print("test");
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
    var msg = _messageController.text;

    var data = {
      "userSignaled": selectedParticipantIds,
      "message": _messageController.text,
      "conversation": conversation,
      "type": "other",
    };
    Response response = await postdata.postDataAuth(context, data, route);
    print(response.statusCode);
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
      messages = messagesList
          .where((element) => element != null)
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  void _showMultiSelectReasons() async {
    List<String>? reasons = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectReason();
      },
    );

    if (reasons != null) {
      setState(() {
        selectedReasons = reasons;
      });
    }
  }

  void showPopupMenu(themeProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Garantir que la modal reste au-dessus du clavier
            ),
            child: Container(
          color: themeProvider.getBackgroundColor(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              H2TextApp(
                text: "Signaler la conversation",
                color: themeProvider.getTextColor(),
              ),
              ElevatedButton(
                  onPressed: () {
                    // Ajoutez l'appel à _showMultiSelectParticipants ici
                    _showMultiSelectParticipants();
                  },
                  child: Text("Sélectionnez les participants")),
              ElevatedButton(
                  onPressed: () {
                    _showMultiSelectReasons();
                  },
                  child: Text("Choisissez la raison du signalement")),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  counterStyle: TextStyle(color: themeProvider.getTextColor()),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: themeProvider.getTextColor(),
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: themeProvider.getTextColor(),
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  hintText: 'Saisissez votre message',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: themeProvider.getTextColor(),
                ),
                controller: _messageController,
                maxLength: 325,
                maxLines: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: ButtonTextApp(
                        text: "Envoyer",
                        color: AppColors.textDarkmode,
                      ),
                      onPressed: () async {
                        _sendreport();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purpleSchood,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      )),
                ],
              )
            ]),
          ))),
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const H4TextApp(
              text: 'Avec ',
            ),
            H3TextApp(text:  widget.participants
                  .map<String>((participant) =>
                      '${participant['firstname']} ${participant['lastname']}')
                  .join(', '),)
            
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

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

                      DateTime dateTime =
                          DateTime.tryParse(time) ?? DateTime.now();
                      String mois = DateFormat('MMMM', 'fr_FR').format(dateTime);
                      String heure =
                          '${dateTime.day} $mois ${dateTime.hour + 2}:${dateTime.minute.toString().padLeft(2, '0')}';

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
                                : AppColors.purpleSchood, // Utilisez différentes couleurs ou styles si nécessaire
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$content',
                                  style: TextStyle(color: Colors.white)),
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
                                      Text('Fichier attaché',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ), // Utilisez une couleur différente pour le texte si nécessaire
                              Text('$heure',
                                  style: TextStyle(color: Colors.white)),
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
                        Icons.file_copy,
                        size: 30,
                        color:  Colors.green,
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

class MultiSelectReason extends StatefulWidget {
  const MultiSelectReason({Key? key}) : super(key: key);
  @override
  State<MultiSelectReason> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelectReason> {
  final List<String> _selectedItems = [];
  void _itemChange(String itemId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemId);
      } else {
        _selectedItems.remove(itemId);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    
    
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    /*OTHER: 'other',
  BULLYING: 'bullying',
  BADCOMPORTMENT: 'badcomportment',
  SPAM: 'spam'*/ 
    List<List<String>> categoriesTable = [
      ["Harcèlement", "Description du harcèlement"],
      ["Contenu offensant", "Description du contenu offensant"],
      ["Spam", "Description du spam"],
      ["Autre", "Autre description"]
    ];
    return AlertDialog(
      title: const Text('Sélectionnez une raisons de signalement'),
      content: SingleChildScrollView(
        child: ListBody(
          children: List.generate(categoriesTable.length, (index) {
            return CheckboxListTile(
              title: Text(categoriesTable[index][0]),
              value: _selectedItems.contains(categoriesTable[index]
                  [0]), // Utilisez la catégorie comme identifiant
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked!) {
                    _selectedItems.add(categoriesTable[index]
                        [0]); // Ajoutez la catégorie aux élémens sélectionnés
                  } else {
                    _selectedItems.remove(categoriesTable[index][0]);
                  }
                });
              },
            );
          }),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Valider'),
        ),
      ],
    );
  }
}





