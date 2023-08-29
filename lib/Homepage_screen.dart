import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/ProfileScreen.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'global.dart' as global;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = '';
  String lastName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.account_circle,
                  size: 40, color: AppColors.purple_Schood),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              H1TextApp(
                text:
                    'Bonjour $firstName $lastName\nComment te sens tu aujourd\'hui ?',
                color: AppColors.background_darkMode,
              ),
              WidgetCard(
                height: 216,
                width: 401,
                title: "Stats hebdomadaire",
              ),
              WidgetCard(
                height: 216,
                width: 401,
                title: "Questionnaires",
              ),
              WidgetCard(
                height: 216,
                width: 401,
                title: "Messagerie",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBarApp(
        index_app: 0,
/*        Userinfo: widget.Userinfo,*/
      ),
    );
  }
}

class WidgetCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;

  const WidgetCard({
    required this.width,
    required this.height,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      color: AppColors.purple_Schood,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2TextApp(text: title, color: AppColors.background_lightMode),
            Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/stats');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    H4TextApp(
                        text: "Voir plus",
                        color: AppColors.background_lightMode),
                    Icon(
                      Icons.forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
