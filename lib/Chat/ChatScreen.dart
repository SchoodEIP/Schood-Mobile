// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/app_colors.dart';
import 'package:schood/utils/bottom_bar_app.dart';
import '../global.dart' as global;

// ...
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.id, required this.participants})
      : super(key: key);

  final String id;
  final List<dynamic> participants;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  bool isTextFieldEmpty = true;
  String id = global.globalToken;
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      setState(() {
        isTextFieldEmpty = messageController.text.isEmpty;
      });
    });
  }

  //PostFileClass postClass = PostFileClass();
  void _sendMessage(String message, BuildContext context) async {
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
        // ignore: use_build_context_synchronously
        _getmessage(context);
      } else {
        print("Erreur lors de l'envoi du message - ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de l'envoi du message - $error");
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  _getfile(BuildContext context) async {
    final getdata = GetClass();
    var id = widget.id;
    var route = "user/file/$id";
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

  @override
  Widget build(BuildContext context) {
    _getmessage(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avec ',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              widget.participants
                  .map<String>((participant) =>
                      '${participant['firstname']} ${participant['lastname']}')
                  .join(', '),
              style: TextStyle(color: Colors.black),
            ),
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

                      DateTime dateTime =
                          DateTime.tryParse(time) ?? DateTime.now();
                      String mois = DateFormat('MMMM').format(dateTime);
                      String heure =
                          '${dateTime.day} $mois ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                      // Alignement en fonction de l'utilisateur du message

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
                                ? Colors.black
                                : Colors
                                    .blue, // Utilisez différentes couleurs ou styles si nécessaire
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$content',
                                  style: TextStyle(
                                      color: Colors
                                          .white)), // Utilisez une couleur différente pour le texte si nécessaire
                              Text('$heure',
                                  style: TextStyle(
                                      color: Colors
                                          .white)), // Utilisez une couleur différente pour le texte si nécessaire
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
                        _sendMessage(messageController.text, context);
                    },
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.file_copy,
                        size: 30,
                        color: isTextFieldEmpty ? Colors.grey : Colors.green,
                      ),
                      onPressed: () {
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
