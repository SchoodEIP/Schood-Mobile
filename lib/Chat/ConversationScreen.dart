import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:schood/Chat/ChatScreen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _messagecontroller = TextEditingController();
  List<Map<String, dynamic>> conversationData = [];
  String conversationId = '';
  Set<String> uniqueUsers = Set<String>();

  Future<List<Map<String, dynamic>>?> _getchatData(BuildContext context) async {
    final getdata = GetClass();

    final response = await getdata.getData(global.globalToken, "user/chat");

    if (response.statusCode == 200) {
      try {
        final chatData = jsonDecode(response.body);

        if (chatData is List) {
          List<Map<String, dynamic>> chatList =
              List<Map<String, dynamic>>.from(chatData);

          for (var item in chatList) {
            conversationId = item['_id'];
            var participants = item['participants'];
            if (participants is List) {
              for (var participant in participants) {
                var firstname = participant['firstname'];
                var lastname = participant['lastname'];
                var id = participant['_id'];

                var user = '$firstname $lastname';
                if (!uniqueUsers.contains(user)) {
                  uniqueUsers.add(user);
                }
              }
            }
          }
        }
      } catch (e) {
        print('Erreur lors du décodage du JSON : $e');
      }
    } else {
      print(
          'Erreur lors de la récupération des données : ${response.statusCode}');
    }
    return null;
  }

  @override
  void initState() {
    _getchatData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.account_circle,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      ),
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
            child: FutureBuilder<List<Map<String, dynamic>>?>(
                future: _getchatData(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: List.generate(uniqueUsers.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        id: conversationId,
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.purpleSchood,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      H4TextApp(
                                        text: uniqueUsers.elementAt(index),
                                        color:
                                            themeProvider.backgroundLightMode,
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
                                      // _deleteConversation();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'delete',
                                        child:
                                            Text('Supprimer la conversation'),
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
                    }),
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarApp(
        indexapp: 3,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: themeProvider.getBackgroundColor(),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(children: [
                    H1TextApp(
                      text: "Nouveau message",
                      color: themeProvider.getTextColor(),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        counterStyle:
                            TextStyle(color: themeProvider.getTextColor()),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: themeProvider.getTextColor()),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: themeProvider.getTextColor()),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Saisissez le nom de votre destinataire',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      style: GoogleFonts.inter(
                          fontSize: 18, color: themeProvider.getTextColor()),
                      controller: _emailcontroller,
                      maxLines: 1,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        counterStyle:
                            TextStyle(color: themeProvider.getTextColor()),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: themeProvider.getTextColor()),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: themeProvider.getTextColor()),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Saisissez votre message',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      style: GoogleFonts.inter(
                          fontSize: 18, color: themeProvider.getTextColor()),
                      controller: _messagecontroller,
                      maxLength: 325,
                      maxLines: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StandardButton(
                          text: "Envoyé",
                        ),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.attach_file)),
                      ],
                    )
                  ]),
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
