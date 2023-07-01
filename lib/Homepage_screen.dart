import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/utils/BottomBarApp.dart';

class HomeScreen extends StatefulWidget {
  //final User? Userinfo;

  //HomeScreen({required this.Userinfo});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = '';
  String lastName = '';

  @override
/*  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    //String userId = widget.Userinfo?.uid ?? '';

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('profiles')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        if (data != null) {
          setState(() {
            firstName = data['Prénom'];
            lastName = data['Nom'];
          });
        }
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    //String userName = widget.Userinfo?.displayName ?? 'no name';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              signOutAndNavigateToLogin(context); // deconnecte l'user
              // Montrer le profil
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: AppColors.purpleSchood,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Text(
                'Hi $firstName $lastName' '\nhow are you feeling today?',
                style: GoogleFonts.inter(fontSize: 30),
              ),
              WidgetCard(
                height: 216,
                width: 401,
                title: "Weekly Stats",
              ),
              WidgetCard(
                height: 216,
                width: 401,
                title: "Surveys",
              ),
              WidgetCard(
                height: 216,
                width: 401,
                title: "Latest Alerts",
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
      color: AppColors.purpleSchood,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
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
                    Text(
                      "See More",
                      style: TextStyle(color: Colors.white),
                    ),
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
