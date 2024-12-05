import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/help_list.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _getcategory();

  }

  _getcategory() async {
    final getdata = GetClass();
    final response = await getdata.getData(global.globalToken, "user/helpNumbersCategories");
    print(response.body);
    
    setState(() {
      categories = jsonDecode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {


    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
              backgroundColor: themeProvider.getBackgroundColor(),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.notifications_none, size: 40, color: AppColors.purpleSchood),
            ),
          ),
          IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/profile');
      },
      icon: Container(
        width: 40, // Ajustez la taille selon vos besoins
        height: 40, // Ajustez la taille selon vos besoins
        child: global.idimageprofil != ""
            ? ClipOval(
                child: Image.network(
                  global.idimageprofil,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.account_circle,
                size: 40,
                color: AppColors.purpleSchood,
              ),
      ),
        )
        ],
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H1TextApp(text: "Aides"),
            const SizedBox(height: 120.0),
             Center(
              child: Column(
  children: categories.isEmpty
  ? [CircularProgressIndicator()]
  : categories.map((category) {
      return HelpButtonWithArrow(
        route: HelpList(categoryId: category['_id'], categoryName: category['name']), // Passer le nom de la catégorie ici
        text: category['name'],
      );
    }).toList(),

              ),
            ),
        ],
        ),
      )),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 4,
      ),
    );
  }
}
/*import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/help_list.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _getcategory();
  }

  _getcategory() async {
    final getdata = GetClass();
    final response = await getdata.getData(global.globalToken, "user/helpNumbersCategories");
    print(response.body);
    setState(() {
      categories = jsonDecode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? photo = global.idimageprofil.isNotEmpty ? base64Decode(global.idimageprofil) : null;

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: buildAppBar(context, global.role),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H1TextApp(text: "Aides"),
              const SizedBox(height: 120.0),
              Center(
                child: Column(
                  children: categories.isEmpty
                      ? [CircularProgressIndicator()]
                      : categories.map((category) {
                          return HelpButtonWithArrow(
                            route: HelpList(categoryId: category['_id'], categoryName: category['name']),
                            text: category['name'],
                          );
                        }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 4,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, String role) {
        final themeProvider = Provider.of<ThemeProvider>(context);
    if (role == "administration") {
      return AppBar(
        backgroundColor: themeProvider.getBackgroundColor(),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
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
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                   // _showDeleteConfirmationDialog(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Action à effectuer lorsque l'utilisateur appuie sur modifier
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return AppBar(
        backgroundColor: themeProvider.getBackgroundColor(),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.notifications_none, size: 40, color: AppColors.purpleSchood),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            icon: Container(
              width: 40,
              height: 40,
              child: Icon(Icons.account_circle, size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      );
    }
  }
}
*/