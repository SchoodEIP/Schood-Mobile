import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/Chat/ChatScreen.dart';
import 'package:schood/Chat/Signaled/Signaledpeople.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/delete.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;
import 'package:intl/intl.dart';

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

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _messageSignaledController = TextEditingController();
  
  List<Map<String, dynamic>> conversations = [];

  List<Person> persons = [];
   String selectedReason= "";
  String selectedParticipantIds = "";
  List<String>? selectedPersons = [];

  void _showMultiSelect() async {
    selectedPersons = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(persons: persons);
      },
    );
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
void _sendreport(BuildContext context, conversation) async {
  final postdata = PostClass();

  if (selectedReason == "") {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez sélectionner une raison.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

if (selectedParticipantIds == "") {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez sélectionner un participant.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  if (selectedReason == "Harcèlement") {
    selectedReason = "bullying";
  } else if (selectedReason == "Contenu offensant") {
    selectedReason = "badcomportment";
  } else if (selectedReason == "Spam") {
    selectedReason = "spam";
  } else {
    selectedReason = "other";
  }

  var route = "shared/report";

  var data = {
    "userSignaled": selectedParticipantIds,
    "message": _messageSignaledController.text,
    "conversation": conversation,
    "type": selectedReason,
  };
                          _messageSignaledController.clear();
                          selectedParticipantIds = "";
                          selectedReason= "";
 showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Votre signalemet à été envoyé.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                                Navigator.of(context).pop();
              },
              child: Text('Retour à la messagerie'),
            ),
          ],
        );});
        try{
  Response response = await postdata.postDataAuth(context, data, route);
        }catch(error){ showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Une erreur est survenue'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                                Navigator.of(context).pop();
              },
              child: Text('Veuillez reessayer plus tard'),
            ),
          ],
        );});}

}


  _createconversation(String message) async {

    if (selectedPersons?.length != 0)
    {
      selectedPersons?.insert(0, global.idtoken);

    try {
      var route = "user/chat";
      var data = {
        "participants": selectedPersons
      }; // Utilisez une clé appropriée
      final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);

      if (response.statusCode == 200) {
        showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message envoyé avec succès'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
      setState(() {
 _getChatData(context).then((value) {
      setState(() {
        conversations = value;
      });
    });
      });       
                Navigator.of(context).pop();        
                
              },
              child: Text('OK'),
            ),
          ],
        );});
        //_sendMessage(message, context, id);

      } else {
        print("Erreur lors de l'envoi du message - ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de l'envoi du message - $error");
    }
    }
    else{
showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez sélectionner au moins une personne.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );});
    }
  }

  void _sendMessage(String message, BuildContext context, String id) async {
    if (file ==null){
    try {
      var route = "user/chat/$id/newMessage";
      var data = {
        'content': message,
      };
      final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);
      if (response.statusCode == 200) {
        _messageController.clear();
 _getChatData(context).then((value) {
      setState(() {
        conversations = value;
      });
    });
      } else {
        print("Erreur lors de l'envoi du message - ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de l'envoi du message - $error");
    }
    }
  else{try {
      var route = "user/chat/$id/newMessage";
      var data = {
        'content': message,
      };
      final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);
      if (response.statusCode == 200) {
        _messageController.clear();
 _getChatData(context).then((value) {
      setState(() {
        conversations = value;
      });
    });
      } else {
        print("Erreur lors de l'envoi du message - ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de l'envoi du message - $error");
    }
        _sendFile(id);
    file= null;
    }
  }
void _showSelectSignaledParticipants(BuildContext context, List<dynamic> participants) async {
  String? selectedParticipantId;
  if (selectedParticipantIds != ""){
       selectedParticipantId = selectedParticipantIds;
  }
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sélectionnez un participant'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: selectedParticipantId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedParticipantId = newValue;
                      });
                    },
                    items: participants.map<DropdownMenuItem<String>>((participant) {
                      String participantId = participant['_id'];
                      String firstName = participant['firstname'] ?? '';
                      String lastName = participant['lastname'] ?? '';

                      if (participantId.isNotEmpty && firstName.isNotEmpty && lastName.isNotEmpty) {
                        String fullName = '$firstName $lastName';
                        return DropdownMenuItem<String>(
                          value: participantId,
                          child: Text(fullName),
                        );
                      } else {
                        return DropdownMenuItem<String>(
                          value: '',
                          child: SizedBox(),
                        );
                      }
                    }).toList(),
                  ),
                ],
              ),
            );
          },
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
              if (selectedParticipantId != null) {
                selectedParticipantIds = selectedParticipantId!;
                Navigator.pop(context, selectedParticipantId);
              }
            },
            child: const Text('Valider'),
          ),
        ],
      );
    },
  );
}
void _showReportDialog(BuildContext context) async {
  String? selectedReportType = selectedReason;

  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Signaler un problème'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    title: Text('Harcèlement'),
                    value: 'Harcèlement',
                    groupValue: selectedReportType,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReportType = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Spam'),
                    value: 'Spam',
                    groupValue: selectedReportType,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReportType = value;
                      });
                    },
                  ), RadioListTile<String>(
                    title: Text("Contenu offensant"),
                    value: 'Contenu offensant',
                    groupValue: selectedReportType,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReportType = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Autre'),
                    value: 'Autre',
                    groupValue: selectedReportType,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReportType = value;
                      });
                    },
                  ),
                ],
              ),
            );
          },
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
              if (selectedReportType != null) {
                selectedReason = selectedReportType!;
                Navigator.pop(context, selectedReportType);
              }
            },
            child: const Text('Valider'),
          ),
        ],
      );
    },
  );
}  
_leavechat(String idconv) async {
    final postdata = PostClass();
    var ide = global.globalToken;
    var route = "user/chat/$idconv/leave";
    var data = {
    };
    final response = await postdata.postDataAuth(context, data, route);

    if (response.statusCode == 200) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vous avez bien quitté la conversation'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                                Navigator.of(context).pop();
setState(() {
   _getChatData(context).then((value) {
      setState(() {
        conversations = value;
      });
    }); _getChatData(context).then((value) {
      setState(() {
        conversations = value;
      });
    });
});
                
              },
              child: Text('OK'),
            ),
          ],
        );});
    } else {
      print("Erreur ${response.statusCode}");
    }
  }

  _getUserData() async {
    final getData = GetClass();
    final response =
        await getData.getData(global.globalToken, "user/chat/users");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      persons = data.map((personData) => Person.fromJson(personData)).toList();

      for (var person in persons) {
        print(
            'ID: ${person.id}, Firstname: ${person.firstname}, Lastname: ${person.lastname}');
      }
    }
  }
void showPopupSignaledMenu(themeProvider,conversation, participants) {
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
                  _showSelectSignaledParticipants(context, participants);
                  },
                  child: Text("Sélectionnez le participant")),
              ElevatedButton(
                  onPressed: () {
                    _showReportDialog(context);
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
                controller: _messageSignaledController,
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
                        _sendreport(context, conversation);

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
  Future<List<Map<String, dynamic>>> _getChatData(BuildContext context) async {
    final getData = GetClass();

    final response = await getData.getData(global.globalToken, "user/chat");

    if (response.statusCode == 200) {
      try {
        final chatData = jsonDecode(response.body);

        if (chatData is List) {
          List<Map<String, dynamic>> chatList = [];

          for (var item in chatData) {
            String conversationId = item['_id'];
            DateTime date = DateTime.parse(item['date']);
            var participants = item['participants'];
            if (participants is List) {
              chatList.add({
                'id': conversationId,
                'participants': participants,
                'date': date
              });
            }
          }
          chatList.sort((a, b) => b['date'].compareTo(a['date']));
          return chatList;
        }
      } catch (e) {
        print('Erreur lors du décodage du JSON : $e');
      }
    } else {
      print(
          'Erreur lors de la récupération des données : ${response.statusCode}');
    }

    return [];
  }

  @override
  void initState() {
    _getChatData(context).then((value) {
      setState(() {
        conversations = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
                 Uint8List ?photo = null;
    if (global.idimageprofil != "") {
      photo = base64Decode(global.idimageprofil);
    }
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
           InkWell(
            onTap: (){ Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
            },
            child: const Padding(
              padding:  EdgeInsets.all(8),
              child: Icon(Icons.notifications_none,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
           IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/profile');
      },
      icon: Container(
        width: 40, // Ajustez la taille selon vos besoins
        height: 40, // Ajustez la taille selon vos besoins
        child: /*global.idimageprofil != ""
            ? ClipOval(
                child: Image.memory(
                  photo!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : */Icon(
                Icons.account_circle,
                size: 40,
                color: AppColors.purpleSchood,
              ),
      ),
        )]),
      backgroundColor: themeProvider.getBackgroundColor(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32),
            child: H1TextApp(
              text: "Messagerie",
              color: themeProvider.getTextColor(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getChatData(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    var conversation = conversations[index];

                    return GestureDetector(
                      onTap: () {
                        print(conversation['']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                id: conversation['id'],
                                participants: conversation['participants']),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.purpleSchood,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const CircleAvatar(),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    H4TextApp(
                                      text: conversation['participants'][0]
                                          ['firstname'],
                                      color: themeProvider.backgroundLightMode,
                                    ),
                                    H4TextApp(
                                      text:
                                          "Créé le ${DateFormat('dd/MM/yyyy').format(conversation['date'])}",
                                      color: themeProvider.backgroundLightMode,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _leavechat(conversation['id']);
                                  }
                                  else if (value == 'signaled'){
                                    showPopupSignaledMenu(themeProvider, conversation['id'], conversation['participants']);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem(
                                      value: 'signaled',
                                      child: Text('Signaler une personne'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Supprimer la conversation'),
                                    ),
                                  ];
                                },
                              ),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarApp(
        indexapp: 3,
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    _getUserData();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Utilisez isScrollControlled pour permettre à la modal d'occuper toute la hauteur de l'écran
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Garantir que la modal reste au-dessus du clavier
            ),
            child: Container(
              color: themeProvider.getBackgroundColor(),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  H1TextApp(
                    text: "Nouveau message",
                    color: themeProvider.getTextColor(),
                  ),
                  ElevatedButton(
                    onPressed: _showMultiSelect,
                    child: Text("Choisissez votre/vos utilisateurs(s)"),
                  ),
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
                            await _createconversation(_messageController.text);
                            List<Map<String, dynamic>> tmp = await _getChatData(context);
                            if (tmp.isNotEmpty ) {
                              String id = tmp.first['id'];
                              print("ID de la première conversation : $id");
                              _sendMessage(_messageController.text, context, id);
setState(() {
   _getChatData(context).then((value) {
      setState(() {
        conversations = value;
      });
    });
});
                          }
                          
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purpleSchood,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                        _openFilePicker();
                          List<Map<String, dynamic>> tmp = await _getChatData(context);
                          if (tmp.isNotEmpty) {
                            String id = tmp.first['id'];
                            print("ID de la première conversation : $id");
                            _sendMessage(_messageController.text, context, id);

                          }
                        },
                        icon: Icon(Icons.attach_file),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  },

        child: Icon(
          Icons.edit,
          color: AppColors.backgroundLightmode,
        ),
        backgroundColor: AppColors.purpleSchood,
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  const MultiSelect({Key? key, required this.persons}) : super(key: key);
  @override
  final List<Person> persons;
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
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
    return AlertDialog(
      title: const Text('Sélectionnez des utilisateurs'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.persons
              .map((person) => CheckboxListTile(
                    value: _selectedItems.contains(person.id),
                    title: Text('${person.firstname} ${person.lastname}'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) =>
                        _itemChange(person.id, isChecked!),
                  ))
              .toList(),
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

