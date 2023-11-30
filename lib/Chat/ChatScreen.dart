// ignore_for_file: file_names
import 'dart:convert';
import 'dart:ffi';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:schood/utils/BottomBarApp.dart';
import '../global.dart' as global;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  bool isTextFieldEmpty = true;
  String id = global.globalToken;
  List<List<dynamic>> data = [
    ['Salut', 'User 1', '2023-09-16 10:00:00'],
    ['Salut à tous', 'User 1', '2024-09-16 10:00:00'],
    ['Salut', 'User 2', '2023-09-16 10:00:00'],
    ['Salut', 'User 2', '2023-09-16 10:00:00'],
    ['Salut', 'User 2', '2023-09-16 10:00:00'],
    ['Salut', 'User 2', '2023-09-16 10:00:00'],
    ['Tu vas bien ?', 'User 1', '2023-09-16 20:30:00'],
    ['Je suis à Auchan', 'User 1', '2023-09-16 23:30:00'],
  ];
  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      setState(() {
        isTextFieldEmpty = messageController.text.isEmpty;
      });
    });
    data.sort((a, b) => DateTime.parse(a[2]).compareTo(DateTime.parse(b[2])));
  }

  PostFileClass postClass = PostFileClass();

  Future<void> sendDataWithFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpeg'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
      }
    } catch (e) {
      print('Erreur lors de la sélection du fichier : $e');
    }
  }

  /* Future<void> pickAndUploadFile(BuildContext context) async {
    final postclass = PostClass();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, // Spécifiez le type de fichier autorisé
        allowedExtensions: ['pdf', 'png', 'jpeg'], // Extensions autorisées
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        Response response =
            await postclass.postData(context, file, 'user/chat/file');
        final body = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Fichier envoyé avec succès');
        } else {
          print('Erreur lors de l\'envoi du fichier : ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Erreur lors de la sélection du fichier : $e');
    }
  }*/

  _messagesend(BuildContext context) async {
    var time = DateTime.now();
    var data = {
      'mailer': 'axou@test.fr',
      'receiver': 'axel2@test2.fr',
      'message': messageController.text.trim(),
      'time': time,
    };
    final postclass = PostClass();
    try {
      postclass.postData(context, data, '/user/chat/$id/newMessage');
      print("nice you send something");
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Une erreur s\'est produite.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  _getchat(BuildContext context) async {
    final getdata = GetClass();
    global.globalToken;
    // Response response = await getdata.getData(global.globalToken, "user/chat");

    //id = response.body;
  }

  _getmessage(BuildContext context) async {
    final getdata = GetClass();
    final token = global.globalToken;
    //print(widget.id);

    Response response2 = await getdata.getData(
        global.globalToken, "/user/chat/$widget.$id/messages");
    print(response2.body);

    //Array<dynamic> userData = jsonDecode(response2.body);
    {}
  }

  @override
  Widget build(BuildContext context) {
    _getchat(context);
    _getmessage(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const H1TextApp(
          text: "M.Math",
          color: AppColors.backgroundDarkmode,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Masquer le clavier lorsque l'utilisateur appuie en dehors du TextField
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
                          children: data.map((messageData) {
                            String message = messageData[0];
                            String user = messageData[1];
                            String time = messageData[2];

                            AlignmentDirectional alignment = user == 'User 2'
                                ? AlignmentDirectional.centerStart
                                : AlignmentDirectional.centerEnd;

                            Color messageColor = user == 'User 2'
                                ? AppColors.purpleSchood
                                : AppColors.pinkSchood;
                            Color textColor = user == 'User 2'
                                ? AppColors.backgroundLightmode
                                : themeProvider.getBackgroundColor();
                            DateTime dateTime = DateTime.parse(time);
                            String mois = DateFormat('MMMM').format(dateTime);
                            String heure = '${dateTime.day} '
                                '$mois '
                                '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}'; // Format HH:mm

                            // Créer un Container pour chaque message
                            return Align(
                              alignment: alignment,
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color:
                                        messageColor, // Couleur de fond du message
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Bords arrondis
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$message',
                                        style: TextStyle(color: textColor),
                                      ),
                                      Text(
                                        '$heure',
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  )),
                            );
                          }).toList(),
                        )))),
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
                      if (!isTextFieldEmpty) _messagesend(context);
                    },
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.file_copy,
                        size: 30,
                        color: isTextFieldEmpty ? Colors.grey : Colors.green,
                      ),
                      onPressed: () {
                        sendDataWithFile(context);
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
