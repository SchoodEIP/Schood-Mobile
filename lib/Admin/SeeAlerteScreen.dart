import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/utils/ErrorMessage.dart';


class Person {
  final String id;
  final String firstname;
  final String lastname;
  final List classe;
final String roleid;
final String rolename;
  Person({required this.id, required this.firstname, required this.lastname,required this.classe,required this.roleid, required this.rolename});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      classe: json['classes'],
      roleid: json['role']['_id'],
      rolename:json['role']['name']
    );
  }
}
class DropdownWidget extends StatelessWidget {
  final List<Person> persons;
  final ValueChanged<String?>? onChanged;
  String? idchoos;
  String rolchoos = "";

  DropdownWidget({required this.persons, required this.onChanged, required this.idchoos});

  @override
  Widget build(BuildContext context) {
    List<String> uniqueRoleIds = [];
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (var person in persons) {
      if (!uniqueRoleIds.contains(person.roleid)) {
        uniqueRoleIds.add(person.roleid);
        String roleDisplayName = _getRoleDisplayName(person.rolename);
        dropdownItems.add(
          DropdownMenuItem<String>(
            value: person.roleid,
            child: Text(roleDisplayName),
          ),
        );
      }
    }

    return DropdownButton<String>(
      onChanged: (selectedRoleId) {
        idchoos = selectedRoleId;
        final selectedPerson = persons.firstWhere(
          (person) => person.roleid == selectedRoleId,
          orElse: () => Person(
            id: '',
            firstname: '',
            lastname: '',
            classe: [],
            roleid: '',
            rolename: '',
          ),
        );
        rolchoos = selectedPerson.rolename;
        print(rolchoos);
        onChanged?.call(selectedRoleId);
      },
      hint: Text(rolchoos ?? 'Sélectionnez un rôle'),
      items: dropdownItems,
    );
  }

  String _getRoleDisplayName(String roleName) {
    print("HEERE AXEL");
    print(roleName);
    switch (roleName) {
      case 'administration':
        return 'Administration';
      case 'admin':
        return 'Administrateur';
      case 'teacher':
        return 'Professeur';
      case 'student':
        return 'Étudiant';
      default:
        return 'Autre';
    }
  }
}




class SeeAlertScreen extends StatefulWidget {
  @override
  _SeeAlertScreenState createState() => _SeeAlertScreenState();
}

class _SeeAlertScreenState extends State<SeeAlertScreen> {
  List<Widget> bodyWidgets = [];
  Map<String, dynamic> userData = {};
  List<Person> persons = [];
  String? idchoos;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _getUserData() async {
    final getData = GetClass();
    final response = await getData.getData(global.globalToken, "user/chat/users");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      persons = data.map((personData) => Person.fromJson(personData)).toList();
      for (var person in persons) {
        print(
            'ID: ${person.id}, Firstname: ${person.firstname}, Lastname: ${person.lastname}, Classe: ${person.classe}');
      }
    }
  }

  Future<void> _initData() async {
    await _getAlert();
    await _getUserData();
  }

 void _showAddAlertPopup(BuildContext context) {
  String title = '';
  String message = '';
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Ajouter une alerte"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Titre de l\'alerte'),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Message'),
                  onChanged: (value) {
                    setState(() {
                      message = value;
                    });
                  },
                ),
                DropdownWidget(
                  persons: persons,
                  idchoos: idchoos,

                  onChanged: (String? selectedRole) {
                    setState(() {
                      idchoos = selectedRole;
                    });
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  _sendAlert(context, title, message);
                  Navigator.of(context).pop();
                },
                child: Text('Envoyer'),
              ),
            ],
          );
        },
      );
    },
  );
}

  _sendAlert(BuildContext context, title, String message) async {
    final getdata = GetClass();
    Response reponse2 =
        await getdata.getData(global.globalToken, "user/profile");

    String roleId = "";
    Map<String, dynamic> responseData = json.decode(reponse2.body);

    Map<String, dynamic> roleData = responseData["role"];
    roleId = roleData["_id"];
    var data = {'title': title, 'message': message, 'role': idchoos, };
    final postclass = PostClass();
    //print(data);
    Response response =
        await postclass.postDataAuth(context, data, "shared/alert");
    print(response.statusCode);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Votre Alerte à bien été envoyé.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

              },
              child: Text('Retour aux alertes'),
            ),
          ],
        );});
  }

  Future<void> _getAlert() async {
    final getdata = GetClass();
    Response response =
        await getdata.getData(global.globalToken, "shared/alert");

    List<Map<String, dynamic>> alerts =
        List<Map<String, dynamic>>.from(jsonDecode(response.body));
    setState(() {
      bodyWidgets = _buildAlertList(alerts);
    });
  }

  Future<void> _showDetailsPopup(Map<String, dynamic> alert) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: H2TextApp(text: "${alert["title"]}"),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H3TextApp(
                    text:
                        "Alerté par: ${alert["createdBy"]['firstname'] + ' ' + alert["createdBy"]['lastname']}"),
                SizedBox(
                  height: 20,
                ),
                H4TextApp(text: "${alert["message"]}"),
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(20),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAlertList(List<Map<String, dynamic>> alerts) {
    return alerts.map((alert) {
      String title = alert["title"] ?? "";
      DateTime createdAt = DateTime.parse(alert["createdAt"]);
      String createdBy = (alert["createdBy"] != null && alert["createdBy"]['firstname'] != null && alert["createdBy"]['lastname'] != null) ? 
                         "${alert["createdBy"]['firstname']} ${alert["createdBy"]['lastname']}" : "";

      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.purpleSchood,
                borderRadius: BorderRadius.circular(26),
              ),
              child: InkWell(
                onTap: () {
                  _showDetailsPopup(alert);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H4TextApp(
                        text: "Créée le $createdAt",
                        color: AppColors.textDarkmode,
                      ),
                      H4TextApp(
                        text: "Titre: $title",
                        color: AppColors.textDarkmode,
                      ),
                      H4TextApp(
                        text: "Par: $createdBy",
                        color: AppColors.textDarkmode,
                      ),
                    ],
                  ),
                ),
              )));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded),
            color: themeProvider.getTextColor(),
            onPressed: () {
              _showAddAlertPopup(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: H1TextApp(
                  text: "Alerte",
                  color: themeProvider.getTextColor(),
                ),
              ),
              const SizedBox(height: 60.0),
              ...bodyWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
