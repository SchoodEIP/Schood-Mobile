import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/Chat/ChatScreen.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> conversations = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Person> persons = [];
  List<String>? selectedPersons = [];

  void _showMultiSelect() async {
    selectedPersons = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(persons: persons);
      },
    );
  }

  _createconversation(String message) async {
    print(selectedPersons);
    selectedPersons?.insert(0, global.idtoken);
    print(selectedPersons);

    try {
      var route = "user/chat";
      var data = {
        "participants": selectedPersons
      }; // Utilisez une clé appropriée
      final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);

      if (response.statusCode == 200) {
        //_sendMessage(message, context, id);
        print("Bien envoyé");
      } else {
        print("Erreur lors de l'envoi du message - ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de l'envoi du message - $error");
    }
  }

  void _sendMessage(String message, BuildContext context, String id) async {
    try {
      var route = "user/chat/$id/newMessage";
      var data = {
        'content': message,
      };
      final postclass = PostClass();
      Response response = await postclass.postDataAuth(context, data, route);
      if (response.statusCode == 200) {
        _messageController.clear();
      } else {
        print("Erreur lors de l'envoi du message - ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de l'envoi du message - $error");
    }
  }

  _deleteconversation() async {
    final delete = DeleteClass();
    final response = await delete.deleteDataAuth(
        context, global.globalToken, "user/chat/delete");
    if (response.statusCode == 200) ;
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

  Future<List<Map<String, dynamic>>> _getChatData(BuildContext context) async {
    final getData = GetClass();

    final response = await getData.getData(global.globalToken, "user/chat");

    if (response.statusCode == 200) {
      try {
        final chatData = jsonDecode(response.body);
        print(chatData);

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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getChatData(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
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
                                    // _deleteConversation();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
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
                    ElevatedButton(
                        onPressed: _showMultiSelect,
                        child: Text("Choisissez votre/vos utilisateurs(s)")),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        counterStyle:
                            TextStyle(color: themeProvider.getTextColor()),
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
                              await _createconversation(
                                  _messageController.text);
                              List<Map<String, dynamic>> tmp =
                                  await _getChatData(context);
                              if (tmp.isNotEmpty) {
                                String id = tmp.first['id'];
                                print("ID de la première conversation : $id");
                                _sendMessage(
                                    _messageController.text, context, id);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purpleSchood,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            )),
                        IconButton(
                          onPressed: () async {
                            await _createconversation(_messageController.text);
                            List<Map<String, dynamic>> tmp =
                                await _getChatData(context);
                            if (tmp.isNotEmpty) {
                              String id = tmp.first['id'];
                              print("ID de la première conversation : $id");
                              _sendMessage(
                                  _messageController.text, context, id);
                            }
                          },
                          icon: Icon(Icons.attach_file),
                        ),
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
